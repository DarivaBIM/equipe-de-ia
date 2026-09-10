#requires -Version 5.1
<#
Transporta versoes JA REVISADAS E COMMITADAS. Nao faz add/commit automatico.
Nao instala tarefas, nao copia credenciais e nao resolve divergencia.
Use somente em repositorio proprio/privado ou institucional autorizado.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$RepoPath,
    [string]$AuthorizedRemote,
    [string]$ManifestPath,
    [ValidateSet('Sync', 'Pause', 'Resume', 'Status')][string]$Mode = 'Sync'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($ManifestPath)) { $ManifestPath = Join-Path $PSScriptRoot 'arquivos-permitidos.json' }
$script:LogPath = $null
$script:Repo = $null
$mutex = $null
$hasLock = $false

function Invoke-RepoGit {
    param([string[]]$GitArgs, [switch]$AllowFailure)
    $oldPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $lines = @(& git -C $script:Repo -c protocol.ext.allow=never @GitArgs 2>&1 | ForEach-Object { "$_" })
        $code = $LASTEXITCODE
    } finally { $ErrorActionPreference = $oldPreference }
    if (($code -ne 0) -and -not $AllowFailure) { throw 'E_GIT_OPERATION' }
    return [pscustomobject]@{ Code = $code; Lines = $lines }
}

function Write-Result {
    param([string]$Action, [string]$Detail, [string]$Commit = '')
    $entry = [ordered]@{
        time = (Get-Date).ToString('o')
        action = $Action
        detail = $Detail
        commit = $Commit
    }
    $json = $entry | ConvertTo-Json -Compress
    if ($script:LogPath) { Add-Content -LiteralPath $script:LogPath -Value $json -Encoding UTF8 }
    Write-Output $json
}

function Assert-AllowedPaths {
    param([string[]]$Paths, [string[]]$Allowed)
    foreach ($path in $Paths) {
        if ([string]::IsNullOrWhiteSpace($path)) { continue }
        if ($Allowed -cnotcontains $path) { throw 'E_PATH_NOT_APPROVED' }
    }
}

function Assert-RegularTree {
    param([string]$Ref, [string[]]$Allowed)
    foreach ($line in (Invoke-RepoGit @('-c', 'core.quotepath=false', 'ls-tree', '-r', $Ref)).Lines) {
        if ($line -notmatch '^(100644|100755) blob [0-9a-f]+\t(.+)$') { throw 'E_TREE_LINK_OR_SPECIAL_FILE' }
        Assert-AllowedPaths @($Matches[2]) $Allowed
    }
}

try {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'E_GIT_MISSING' }
    $item = Get-Item -LiteralPath $RepoPath -Force
    if (-not $item.PSIsContainer -or ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
        throw 'E_ROOT_OR_LINK'
    }
    $script:Repo = $item.FullName.TrimEnd([char[]]'\/')
    foreach ($privateName in @('.claude', '.codex')) {
        $privateRoot = [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE $privateName)).TrimEnd('\')
        if ($script:Repo.Equals($privateRoot, [StringComparison]::OrdinalIgnoreCase) -or
            $script:Repo.StartsWith($privateRoot + '\', [StringComparison]::OrdinalIgnoreCase)) {
            throw 'E_PRIVATE_APP_DIRECTORY'
        }
    }
    $top = (Invoke-RepoGit @('rev-parse', '--show-toplevel')).Lines[0]
    if (-not [IO.Path]::GetFullPath($top).TrimEnd([char[]]'\/').Equals($script:Repo, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'E_NOT_REPOSITORY_ROOT'
    }
    $gitDir = [IO.Path]::GetFullPath((Invoke-RepoGit @('rev-parse', '--absolute-git-dir')).Lines[0])
    if (-not $gitDir.Equals((Join-Path $script:Repo '.git'), [StringComparison]::OrdinalIgnoreCase)) {
        throw 'E_WORKTREE_NOT_SUPPORTED'
    }
    if ((Get-Item -LiteralPath $gitDir -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) {
        throw 'E_ROOT_OR_LINK'
    }
    $script:LogPath = Join-Path $gitDir 'sync-casa.log'
    $pausePath = Join-Path $gitDir 'sync-casa.paused'
    $hashObject = [Security.Cryptography.SHA256]::Create()
    try { $lockId = [BitConverter]::ToString($hashObject.ComputeHash([Text.Encoding]::UTF8.GetBytes($script:Repo.ToLowerInvariant()))).Replace('-', '') }
    finally { $hashObject.Dispose() }
    $mutex = New-Object Threading.Mutex($false, ('Local\FEELT-Sync-' + $lockId))
    try { $hasLock = $mutex.WaitOne(0) } catch [Threading.AbandonedMutexException] { $hasLock = $true }
    if (-not $hasLock) { Write-Result 'skip' 'LOCK_BUSY'; exit 0 }

    if ($Mode -eq 'Pause') {
        Set-Content -LiteralPath $pausePath -Value 'paused by owner' -Encoding ASCII
        Write-Result 'paused' 'LOCAL_FLAG_SET'; exit 0
    }
    if ($Mode -eq 'Resume') {
        if (Test-Path -LiteralPath $pausePath) { Remove-Item -LiteralPath $pausePath }
        Write-Result 'resumed' 'LOCAL_FLAG_REMOVED'; exit 0
    }
    if ($Mode -eq 'Status') {
        $state = if (Test-Path -LiteralPath $pausePath) { 'PAUSED' } else { 'ENABLED' }
        Write-Output ('Local state: ' + $state)
        if (Test-Path -LiteralPath $script:LogPath) { Get-Content -LiteralPath $script:LogPath -Tail 1 }
        exit 0
    }
    if (Test-Path -LiteralPath $pausePath) { Write-Result 'skip' 'PAUSED'; exit 0 }

    if ([string]::IsNullOrWhiteSpace($AuthorizedRemote) -or $AuthorizedRemote -match '[\r\n?&#]' -or
        $AuthorizedRemote -match '://[^/]*@' -or $AuthorizedRemote -match '^ext::') {
        throw 'E_REMOTE_REQUIRED_WITHOUT_SECRET'
    }
    $remote = Invoke-RepoGit @('config', '--get', 'remote.origin.url')
    if ($remote.Lines.Count -ne 1 -or $remote.Lines[0] -cne $AuthorizedRemote) { throw 'E_REMOTE_MISMATCH' }
    $pushUrls = Invoke-RepoGit @('config', '--get-all', 'remote.origin.pushurl') -AllowFailure
    if (($pushUrls.Code -eq 0) -and ($pushUrls.Lines.Count -ne 1 -or $pushUrls.Lines[0] -cne $AuthorizedRemote)) {
        throw 'E_PUSH_REMOTE_MISMATCH'
    }
    $effectiveFetch = Invoke-RepoGit @('remote', 'get-url', '--all', 'origin')
    $effectivePush = Invoke-RepoGit @('remote', 'get-url', '--push', '--all', 'origin')
    if ($effectiveFetch.Lines.Count -ne 1 -or $effectiveFetch.Lines[0] -cne $AuthorizedRemote -or
        $effectivePush.Lines.Count -ne 1 -or $effectivePush.Lines[0] -cne $AuthorizedRemote) {
        throw 'E_EFFECTIVE_REMOTE_MISMATCH'
    }
    $mirror = Invoke-RepoGit @('config', '--get', 'remote.origin.mirror') -AllowFailure
    if (($mirror.Code -eq 0) -and $mirror.Lines[0] -eq 'true') { throw 'E_MIRROR_NOT_SUPPORTED' }
    $branch = (Invoke-RepoGit @('branch', '--show-current')).Lines[0]
    if ($branch -cne 'main') { throw 'E_BRANCH_NOT_MAIN' }
    foreach ($marker in @('MERGE_HEAD', 'CHERRY_PICK_HEAD', 'REVERT_HEAD', 'rebase-merge', 'rebase-apply', 'index.lock')) {
        if (Test-Path -LiteralPath (Join-Path $gitDir $marker)) { throw 'E_OPERATION_IN_PROGRESS' }
    }
    if ((Invoke-RepoGit @('status', '--porcelain', '--untracked-files=all')).Lines.Count -gt 0) {
        throw 'E_DIRTY_REVIEW_AND_COMMIT_FIRST'
    }
    $localHead = (Invoke-RepoGit @('rev-parse', 'HEAD')).Lines[0]

    $manifestData = Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json
    $allowed = @($manifestData)
    if ($allowed.Count -eq 0) { throw 'E_EMPTY_MANIFEST' }
    foreach ($path in $allowed) {
        if ($path -isnot [string] -or $path -match '(^/|\\|(^|/)\.\.(/|$)|[:*?\[\]\r\n])' -or
            $path -match '(^|/)(\.git|\.env($|\.)|\.credentials\.json|[^/]*\.(pem|key|pfx))($|/)') {
            throw 'E_INVALID_MANIFEST_PATH'
        }
        $cursor = $script:Repo
        foreach ($part in $path.Split('/')) {
            $cursor = Join-Path $cursor $part
            if ((Test-Path -LiteralPath $cursor) -and
                ((Get-Item -LiteralPath $cursor -Force).Attributes -band [IO.FileAttributes]::ReparsePoint)) {
                throw 'E_LINK_NOT_SUPPORTED'
            }
        }
        if ((Test-Path -LiteralPath $cursor) -and (Get-Item -LiteralPath $cursor -Force).PSIsContainer) {
            throw 'E_MANIFEST_REQUIRES_EXACT_FILES'
        }
    }
    Assert-AllowedPaths (Invoke-RepoGit @('-c', 'core.quotepath=false', 'ls-files')).Lines $allowed
    Assert-RegularTree $localHead $allowed

    # Download only; no rebase or merge until the history and paths are checked.
    $fetch = Invoke-RepoGit @('fetch', '--no-tags', 'origin', 'refs/heads/main:refs/remotes/origin/main') -AllowFailure
    if ($fetch.Code -ne 0) { throw 'E_FETCH_FAILED_NO_TRANSFER_CONFIRMED' }
    $remoteHead = (Invoke-RepoGit @('rev-parse', 'refs/remotes/origin/main')).Lines[0]
    Assert-RegularTree $remoteHead $allowed
    $counts = ((Invoke-RepoGit @('rev-list', '--left-right', '--count', ($localHead + '...' + $remoteHead))).Lines[0]).Trim() -split '\s+'
    $ahead = [int]$counts[0]; $behind = [int]$counts[1]
    if ($ahead -gt 0 -and $behind -gt 0) { throw 'E_DIVERGED_HUMAN_REQUIRED' }
    if ($ahead -eq 0 -and $behind -eq 0) {
        Write-Result 'skip' 'ALREADY_EQUAL' $localHead; exit 0
    }
    $range = if ($ahead -gt 0) { $remoteHead + '..' + $localHead } else { $localHead + '..' + $remoteHead }
    Assert-AllowedPaths (Invoke-RepoGit @('-c', 'core.quotepath=false', 'log', '--format=', '--name-only', $range)).Lines $allowed
    # Recheck before changing the checkout or sending. One writer still remains a human rule.
    if ((Invoke-RepoGit @('status', '--porcelain', '--untracked-files=all')).Lines.Count -gt 0) { throw 'E_DIRTY_CHANGED_DURING_CHECK' }
    if ((Invoke-RepoGit @('rev-parse', 'HEAD')).Lines[0] -cne $localHead) { throw 'E_HEAD_CHANGED_DURING_CHECK' }
    if ($behind -gt 0) {
        $expected = $remoteHead
        Invoke-RepoGit @('merge', '--ff-only', $remoteHead) | Out-Null
        $head = (Invoke-RepoGit @('rev-parse', 'HEAD')).Lines[0]
        if ($head -cne $expected) { throw 'E_RECEIVE_VERIFY_FAILED' }
        Write-Result 'received' 'LOCAL_HEAD_MATCHES_FETCHED_MAIN' $head
    } else {
        $head = $localHead
        $push = Invoke-RepoGit @('push', 'origin', ($head + ':refs/heads/main')) -AllowFailure
        if ($push.Code -ne 0) { throw 'E_PUSH_FAILED_VERIFY_BEFORE_RETRY' }
        $confirmed = (Invoke-RepoGit @('ls-remote', '--heads', 'origin', 'refs/heads/main')).Lines
        if ($confirmed.Count -ne 1 -or ($confirmed[0] -split '\s+')[0] -cne $head) { throw 'E_REMOTE_VERIFY_FAILED' }
        Write-Result 'sent' 'REMOTE_MAIN_CONFIRMED' $head
    }
    exit 0
} catch {
    $detail = if ($_.Exception.Message -match '^E_[A-Z_]+$') { $_.Exception.Message } else { 'E_LOCAL_FAILURE_CHECK_REPOSITORY' }
    try { Write-Result 'error' $detail } catch { Write-Output ('error: ' + $detail + ' (LOG_UNAVAILABLE)') }
    exit 1
} finally {
    if ($hasLock) { try { $mutex.ReleaseMutex() } catch {} }
    if ($mutex) { $mutex.Dispose() }
}
