#requires -Version 5.1
<# SIMULACAO LOCAL: duas pastas neste computador e um Git remoto local.
Nao acessa rede, nao usa logins, nao agenda tarefas e nao altera configuracao global.
Cada execucao cria uma pasta nova e preserva os resultados.
#>
[CmdletBinding()]
param(
    [string]$OutputRoot,
    [switch]$TestarFalhas
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($OutputRoot)) { $OutputRoot = Join-Path $PSScriptRoot 'provas-locais' }
$results = New-Object 'System.Collections.Generic.List[object]'
$runPath = $null
$syncScript = Join-Path $PSScriptRoot 'Sync-Casa.ps1'
$manifest = Join-Path $PSScriptRoot 'arquivos-permitidos.json'
$engine = Join-Path $PSHOME 'powershell.exe'
if (-not (Test-Path -LiteralPath $engine)) { $engine = Join-Path $PSHOME 'pwsh.exe' }

function Local-Git {
    param([string]$Path, [string[]]$GitArgs)
    $old = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $lines = @(& git -C $Path -c commit.gpgsign=false -c core.autocrlf=false @GitArgs 2>&1 | ForEach-Object { "$_" })
        $exitCode = $LASTEXITCODE
    } finally { $ErrorActionPreference = $old }
    if ($exitCode -ne 0) { throw ('Fixture Git failed: ' + ($GitArgs -join ' ')) }
    return [pscustomobject]@{ Lines = $lines }
}

function Run-Sync {
    param([string]$Path, [string]$Remote, [string]$Mode = 'Sync', [switch]$UseDefaultManifest)
    $syncArgs = @('-NoProfile', '-NonInteractive', '-File', $syncScript, '-RepoPath', $Path, '-AuthorizedRemote', $Remote, '-Mode', $Mode)
    if (-not $UseDefaultManifest) { $syncArgs += @('-ManifestPath', $manifest) }
    $lines = @(& $engine @syncArgs 2>&1 | ForEach-Object { "$_" })
    $exitCode = $LASTEXITCODE
    $json = @($lines | Where-Object { $_.StartsWith('{') })
    if ($json.Count -ne 1) { throw ('Unexpected sync output: ' + ($lines -join ' ')) }
    $entry = $json[0] | ConvertFrom-Json
    return [pscustomobject]@{ ExitCode = $exitCode; Entry = $entry }
}

function Assert-Case {
    param([string]$Name, [bool]$Passed, [string]$Evidence)
    $results.Add([pscustomobject]@{ test = $Name; passed = $Passed; evidence = $Evidence })
    if (-not $Passed) { throw ('FAILED: ' + $Name + ' | ' + $Evidence) }
    Write-Output ('PASS | ' + $Name + ' | ' + $Evidence)
}

function Configure-Fixture {
    param([string]$Path)
    Local-Git $Path @('config', '--local', 'user.name', 'Oficina FEELT (simulacao)') | Out-Null
    Local-Git $Path @('config', '--local', 'user.email', 'feelt-simulacao@example.invalid') | Out-Null
    Local-Git $Path @('config', '--local', 'core.hooksPath', $emptyHooks) | Out-Null
}

try {
    $root = [IO.Path]::GetFullPath($OutputRoot)
    if (-not (Test-Path -LiteralPath $root)) { New-Item -ItemType Directory -Path $root | Out-Null }
    if ((Get-Item -LiteralPath $root -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) { throw 'OutputRoot must not be a junction/link.' }
    $runPath = Join-Path $root ((Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [Guid]::NewGuid().ToString('N').Substring(0, 8))
    if (-not $runPath.StartsWith($root.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Path outside requested output root.' }
    if (Test-Path -LiteralPath $runPath) { throw 'New run directory already exists.' }
    New-Item -ItemType Directory -Path $runPath | Out-Null
    $room = Join-Path $runPath 'computador-sala'
    $remote = Join-Path $runPath 'remoto-local.git'
    $notebook = Join-Path $runPath 'notebook-local'
    $emptyHooks = Join-Path $runPath 'hooks-vazios'
    New-Item -ItemType Directory -Path $emptyHooks | Out-Null
    Write-Output 'SIMULACAO LOCAL - estas pastas NAO sao dois computadores reais.'
    Write-Output ('Pasta da prova: ' + $runPath)

    Local-Git $runPath @('init', '--bare', '--initial-branch=main', '--template=', $remote) | Out-Null
    Local-Git $runPath @('init', '--initial-branch=main', '--template=', $room) | Out-Null
    Configure-Fixture $room
    Set-Content -LiteralPath (Join-Path $room '.gitignore') -Value '/dados-restritos.txt' -Encoding ASCII
    Set-Content -LiteralPath (Join-Path $room 'CLAUDE.md') -Value '# Claude: leia estado-atual.md e confirme o proximo passo.' -Encoding ASCII
    Set-Content -LiteralPath (Join-Path $room 'AGENTS.md') -Value '# Codex: leia estado-atual.md e confirme o proximo passo.' -Encoding ASCII
    Set-Content -LiteralPath (Join-Path $room 'estado-atual.md') -Value 'Base sintetica da oficina; nenhuma pessoa real.' -Encoding ASCII
    Local-Git $room @('add', '--', '.gitignore', 'CLAUDE.md', 'AGENTS.md', 'estado-atual.md') | Out-Null
    Local-Git $room @('commit', '-m', 'fixture: base sintetica da oficina') | Out-Null
    Local-Git $room @('remote', 'add', 'origin', $remote) | Out-Null
    Local-Git $room @('push', '-u', 'origin', 'main') | Out-Null
    Local-Git $runPath @('clone', '--no-hardlinks', '--template=', $remote, $notebook) | Out-Null
    Configure-Fixture $notebook

    Set-Content -LiteralPath (Join-Path $room 'estado-atual.md') -Value 'FEELT-RETOMADA-01 | Proximo passo: conferir as fontes do relatorio sintetico.' -Encoding ASCII
    New-Item -ItemType Directory -Path (Join-Path $room 'fontes') | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $room 'gestao') | Out-Null
    Set-Content -LiteralPath (Join-Path $room 'fontes\01-reuniao-sintetica.md') -Value 'Fonte FICTICIA: reuniao da oficina. Prazo ainda nao confirmado.' -Encoding ASCII
    Set-Content -LiteralPath (Join-Path $room 'gestao\relatorio-verificado.md') -Value 'Minuta FICTICIA conferida para oficina, sem homologacao. Fonte: fontes/01-reuniao-sintetica.md. Prazo pendente.' -Encoding ASCII
    Set-Content -LiteralPath (Join-Path $room 'gestao\pauta-reuniao.md') -Value 'Pauta FICTICIA: confirmar o prazo indicado como pendente pela fonte.' -Encoding ASCII
    Set-Content -LiteralPath (Join-Path $room 'gestao\registro-uso-ia.md') -Value 'SIMULACAO: arquivos preparados para testar transporte; nenhuma IA foi consultada por este script.' -Encoding ASCII
    Set-Content -LiteralPath (Join-Path $room 'handoff.md') -Value 'FEELT-RETOMADA-01 | Abrir gestao/relatorio-verificado.md, gestao/pauta-reuniao.md e fontes/01-reuniao-sintetica.md antes de continuar.' -Encoding ASCII
    Local-Git $room @('add', '--', 'estado-atual.md', 'handoff.md', 'fontes/01-reuniao-sintetica.md', 'gestao/relatorio-verificado.md', 'gestao/pauta-reuniao.md', 'gestao/registro-uso-ia.md') | Out-Null
    Local-Git $room @('commit', '-m', 'fixture: marcador revisado para retomada') | Out-Null
    $sent = Run-Sync $room $remote
    Assert-Case 'envio confirmado' ($sent.ExitCode -eq 0 -and $sent.Entry.action -eq 'sent') ($sent.Entry.detail + ' ' + $sent.Entry.commit)
    $received = Run-Sync $notebook $remote
    Assert-Case 'recebimento confirmado' ($received.ExitCode -eq 0 -and $received.Entry.action -eq 'received') ($received.Entry.detail + ' ' + $received.Entry.commit)
    $roomHead = (Local-Git $room @('rev-parse', 'HEAD')).Lines[0]
    $notebookHead = (Local-Git $notebook @('rev-parse', 'HEAD')).Lines[0]
    $bareHead = (Local-Git $remote @('rev-parse', 'refs/heads/main')).Lines[0]
    $marker = (Get-Content -LiteralPath (Join-Path $notebook 'estado-atual.md') -Raw).Trim()
    $author = (Local-Git $notebook @('log', '-1', '--format=%an <%ae>')).Lines[0]
    Assert-Case 'marcador e tres referencias iguais' ($marker -match 'FEELT-RETOMADA-01' -and $roomHead -eq $notebookHead -and $notebookHead -eq $bareHead) ($marker + ' | ' + $notebookHead)
    Assert-Case 'autoria sintetica explicita' ($author -eq 'Oficina FEELT (simulacao) <feelt-simulacao@example.invalid>') $author
    $linkedProducts = @('gestao/relatorio-verificado.md', 'gestao/pauta-reuniao.md', 'fontes/01-reuniao-sintetica.md')
    $handoffText = Get-Content -LiteralPath (Join-Path $notebook 'handoff.md') -Raw
    $linksArrived = $true
    foreach ($product in $linkedProducts) {
        if (-not (Test-Path -LiteralPath (Join-Path $notebook $product)) -or -not $handoffText.Contains($product)) { $linksArrived = $false }
    }
    Assert-Case 'handoff aponta para produtos recebidos' $linksArrived 'relatorio-verificado, pauta e fonte existem no destino e sao citados pelo handoff'

    Set-Content -LiteralPath (Join-Path $room 'dados-restritos.txt') -Value 'DADO FICTICIO: deve ficar somente nesta pasta.' -Encoding ASCII
    $noChange = Run-Sync $room $remote
    $remoteFiles = (Local-Git $remote @('ls-tree', '-r', '--name-only', 'main')).Lines
    Assert-Case 'arquivo excluido nao viaja' ($noChange.Entry.action -eq 'skip' -and $remoteFiles -notcontains 'dados-restritos.txt') ($noChange.Entry.detail + '; remoto nao lista dados-restritos.txt')
    $defaultManifest = Run-Sync $room $remote -UseDefaultManifest
    Assert-Case 'entrada do guia sem ManifestPath' ($defaultManifest.ExitCode -eq 0 -and $defaultManifest.Entry.detail -eq 'ALREADY_EQUAL') $defaultManifest.Entry.detail

    if ($TestarFalhas) {
        $mismatch = Run-Sync $room (Join-Path $runPath 'destino-nao-confirmado.git')
        Assert-Case 'destino divergente interrompe' ($mismatch.ExitCode -eq 1 -and $mismatch.Entry.detail -eq 'E_REMOTE_MISMATCH') $mismatch.Entry.detail

        $outside = Join-Path $runPath 'ensaio-arquivo-fora'
        Local-Git $runPath @('clone', '--no-hardlinks', '--template=', $remote, $outside) | Out-Null
        Configure-Fixture $outside
        Set-Content -LiteralPath (Join-Path $outside 'fora-da-lista.md') -Value 'ARQUIVO FICTICIO fora da lista explicita.' -Encoding ASCII
        Local-Git $outside @('add', '--', 'fora-da-lista.md') | Out-Null
        Local-Git $outside @('commit', '-m', 'fixture: caminho nao aprovado') | Out-Null
        $blockedPath = Run-Sync $outside $remote
        $afterBlockedRemote = (Local-Git $remote @('rev-parse', 'refs/heads/main')).Lines[0]
        Assert-Case 'commit fora da lista nao enviado' ($blockedPath.ExitCode -eq 1 -and $blockedPath.Entry.detail -eq 'E_PATH_NOT_APPROVED' -and $afterBlockedRemote -eq $bareHead) ($blockedPath.Entry.detail + '; remoto preservado')

        $rewriteRoom = Join-Path $runPath 'ensaio-reescrita'
        $rewriteRemote = Join-Path $runPath 'outro-destino.git'
        Local-Git $runPath @('clone', '--no-hardlinks', '--template=', $remote, $rewriteRoom) | Out-Null
        Local-Git $runPath @('clone', '--bare', '--template=', $remote, $rewriteRemote) | Out-Null
        Configure-Fixture $rewriteRoom
        Add-Content -LiteralPath (Join-Path $rewriteRoom 'estado-atual.md') -Value 'VERSAO FICTICIA apenas para o destino autorizado.' -Encoding ASCII
        Local-Git $rewriteRoom @('add', '--', 'estado-atual.md') | Out-Null
        Local-Git $rewriteRoom @('commit', '-m', 'fixture: destino exato aprovado') | Out-Null
        foreach ($rewriteMode in @('pushInsteadOf', 'insteadOf')) {
            $rewriteKey = 'url.' + $rewriteRemote + '.' + $rewriteMode
            Local-Git $rewriteRoom @('config', '--local', $rewriteKey, $remote) | Out-Null
            $rewrite = Run-Sync $rewriteRoom $remote
            $approvedAfter = (Local-Git $remote @('rev-parse', 'refs/heads/main')).Lines[0]
            $otherAfter = (Local-Git $rewriteRemote @('rev-parse', 'refs/heads/main')).Lines[0]
            Assert-Case ('reescrita ' + $rewriteMode + ' interrompe antes do envio') ($rewrite.ExitCode -eq 1 -and $rewrite.Entry.detail -eq 'E_EFFECTIVE_REMOTE_MISMATCH' -and $approvedAfter -eq $bareHead -and $otherAfter -eq $bareHead) ($rewrite.Entry.detail + '; os dois destinos preservados')
            Local-Git $rewriteRoom @('config', '--local', '--unset', $rewriteKey) | Out-Null
        }

        $pause = Run-Sync $room $remote 'Pause'
        $paused = Run-Sync $room $remote
        $resume = Run-Sync $room $remote 'Resume'
        Assert-Case 'pausa local' ($pause.Entry.action -eq 'paused' -and $paused.Entry.detail -eq 'PAUSED' -and $resume.Entry.action -eq 'resumed') 'PAUSED; nenhuma tarefa real foi criada'

        Set-Content -LiteralPath (Join-Path $room 'rascunho-nao-aprovado.md') -Value 'Este arquivo ainda nao foi revisado.' -Encoding ASCII
        $dirty = Run-Sync $room $remote
        Assert-Case 'arquivo nao revisado interrompe' ($dirty.ExitCode -eq 1 -and $dirty.Entry.detail -eq 'E_DIRTY_REVIEW_AND_COMMIT_FIRST') $dirty.Entry.detail
        # Preserve the unapproved file outside the fixture repository; do not delete it.
        $held = Join-Path $runPath 'rascunho-preservado.md'
        Move-Item -LiteralPath (Join-Path $room 'rascunho-nao-aprovado.md') -Destination $held

        $offlineRemote = Join-Path $runPath 'remoto-inexistente.git'
        Local-Git $room @('remote', 'set-url', 'origin', $offlineRemote) | Out-Null
        $beforeOffline = (Local-Git $room @('rev-parse', 'HEAD')).Lines[0]
        $offline = Run-Sync $room $offlineRemote
        $afterOffline = (Local-Git $room @('rev-parse', 'HEAD')).Lines[0]
        Assert-Case 'remoto indisponivel simulado' ($offline.ExitCode -eq 1 -and $offline.Entry.detail -eq 'E_FETCH_FAILED_NO_TRANSFER_CONFIRMED' -and $beforeOffline -eq $afterOffline) ($offline.Entry.detail + '; HEAD preservado')
        Local-Git $room @('remote', 'set-url', 'origin', $remote) | Out-Null

        Add-Content -LiteralPath (Join-Path $room 'estado-atual.md') -Value 'Edicao A - computador da sala.' -Encoding ASCII
        Local-Git $room @('add', '--', 'estado-atual.md') | Out-Null
        Local-Git $room @('commit', '-m', 'fixture: edicao A independente') | Out-Null
        $beforeDiverged = (Local-Git $room @('rev-parse', 'HEAD')).Lines[0]
        Add-Content -LiteralPath (Join-Path $notebook 'estado-atual.md') -Value 'Edicao B - notebook local.' -Encoding ASCII
        Local-Git $notebook @('add', '--', 'estado-atual.md') | Out-Null
        Local-Git $notebook @('commit', '-m', 'fixture: edicao B independente') | Out-Null
        $otherSent = Run-Sync $notebook $remote
        $diverged = Run-Sync $room $remote
        $afterDiverged = (Local-Git $room @('rev-parse', 'HEAD')).Lines[0]
        Assert-Case 'divergencia exige humano' ($otherSent.Entry.action -eq 'sent' -and $diverged.ExitCode -eq 1 -and $diverged.Entry.detail -eq 'E_DIVERGED_HUMAN_REQUIRED' -and $beforeDiverged -eq $afterDiverged) ($diverged.Entry.detail + '; ambas edicoes preservadas, sem merge/rebase')
    }
    $report = [ordered]@{
        kind = 'SIMULACAO LOCAL; um unico host; sem rede ou credenciais'
        passed = $true
        observedAt = (Get-Date).ToString('o')
        powershell = $PSVersionTable.PSVersion.ToString()
        runDirectory = $runPath
        sharedCommitBeforeNegativeTests = $notebookHead
        checks = @($results.ToArray())
    }
    $report | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $runPath 'resultado.json') -Encoding UTF8
    Write-Output ('RESULTADO: ' + (Join-Path $runPath 'resultado.json'))
    Write-Output 'A prova valida transporte de arquivos nesta simulacao. Nao valida login, nuvem ou retomada de IA em segundo computador.'
} catch {
    $failure = $_.Exception.Message
    try {
        if ($runPath -and (Test-Path -LiteralPath $runPath -PathType Container)) {
            $failedReport = [ordered]@{
                kind = 'SIMULACAO LOCAL; um unico host; sem rede ou credenciais'
                passed = $false
                observedAt = (Get-Date).ToString('o')
                powershell = $PSVersionTable.PSVersion.ToString()
                runDirectory = $runPath
                failure = $failure
                checks = @($results.ToArray())
            }
            $failedReport | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $runPath 'resultado.json') -Encoding UTF8
            Write-Output ('RESULTADO COM FALHA: ' + (Join-Path $runPath 'resultado.json'))
        } else { Write-Output 'Sem pasta de prova disponivel para gravar JSON; preserve esta mensagem.' }
    } catch { Write-Output 'Nao foi possivel gravar o JSON da falha; preserve a mensagem e o caminho da prova.' }
    Write-Error -Message $failure -ErrorAction Continue
    exit 1
}
