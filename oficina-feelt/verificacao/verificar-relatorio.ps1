# Verificador local do caso sintético. Somente leitura; não acessa rede ou configurações.
[CmdletBinding()]
param(
    [string]$Caminho,
    [string]$Pauta,
    [switch]$Autoteste
)

$ErrorActionPreference = 'Stop'

function Normalize-Value {
    param([string]$Value)
    $decomposed = $Value.Normalize([Text.NormalizationForm]::FormD)
    $plain = -join ($decomposed.ToCharArray() | Where-Object {
        [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne
            [Globalization.UnicodeCategory]::NonSpacingMark
    })
    return ($plain.ToLowerInvariant() -replace '[*_`]', '' -replace '\s+', ' ').Trim()
}

function Test-ReportContent {
    param([string]$Content)
    $rows = @{}
    $problems = [Collections.Generic.List[string]]::new()
    $inTargetTable = $false
    $headerCount = 0
    foreach ($line in ($Content -split '\r?\n')) {
        if ($line -notmatch '^\s*\|') { $inTargetTable = $false; continue }
        $cells = @($line.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() })
        if ($cells.Count -eq 0) { continue }
        $normalized = @($cells | ForEach-Object { Normalize-Value $_ })
        if (($normalized -join '|') -eq 'item|situacao|data/prazo|evidencia') {
            $headerCount++
            $inTargetTable = $true
            continue
        }
        if (-not $inTargetTable) { continue }
        $item = (Normalize-Value $cells[0]).ToUpperInvariant()
        if ($item -notin @('CAL-02', 'OFI-01', 'ORC-03')) { continue }
        if ($cells.Count -ne 4) { $problems.Add("$item precisa de quatro colunas."); continue }
        if ($rows.ContainsKey($item)) { $problems.Add("$item aparece mais de uma vez."); continue }
        $rows[$item] = $normalized
    }
    if ($headerCount -ne 1) { $problems.Add('Exige exatamente uma tabela com cabecalho Item | Situacao | Data/prazo | Evidencia.') }
    foreach ($item in @('CAL-02', 'OFI-01', 'ORC-03')) {
        if (-not $rows.ContainsKey($item)) { $problems.Add("Linha $item ausente.") }
    }
    if ($problems.Count -gt 0) {
        return [pscustomobject]@{ StructureOk = $false; Problems = @($problems); Checks = @() }
    }
    $cal = $rows['CAL-02']; $ofi = $rows['OFI-01']; $orc = $rows['ORC-03']
    $checks = @(
        [pscustomobject]@{
            Id = 'CAL-02-SITUACAO';
            Passed = ($cal[1] -eq 'em andamento' -and $cal[3] -match '\bf[13]\b');
            Expected = 'Em andamento, com F1 ou F3 como evidencia';
            Observed = "$($cal[1]); $($cal[3])"
        },
        [pscustomobject]@{
            Id = 'CAL-02-DATA';
            Passed = ($cal[2] -eq 'nao informada');
            Expected = 'Nao informada'; Observed = $cal[2]
        },
        [pscustomobject]@{
            Id = 'OFI-01-AGENDA';
            Passed = ($ofi[1] -eq 'confirmada' -and
                $ofi[2] -match '^18/09/2026 (as )?14(h|h00|:00)$' -and
                $ofi[3] -match '\bf2\b');
            Expected = 'Confirmada em 18/09/2026 as 14h, fonte F2';
            Observed = "$($ofi[1]); $($ofi[2]); $($ofi[3])"
        },
        [pscustomobject]@{
            Id = 'ORC-03-PENDENCIA';
            Passed = ($orc[1] -eq 'aguardando aprovacao' -and $orc[2] -eq 'nao informada' -and
                $orc[3] -match '\bf[13]\b');
            Expected = 'Aguardando aprovacao, data nao informada, fonte F1 ou F3';
            Observed = "$($orc[1]); $($orc[2]); $($orc[3])"
        }
    )
    return [pscustomobject]@{ StructureOk = $true; Problems = @(); Checks = $checks }
}

function Read-Report {
    param([string]$ReportPath)
    if (-not (Test-Path -LiteralPath $ReportPath -PathType Leaf)) {
        throw "Arquivo nao encontrado: $ReportPath"
    }
    return Get-Content -LiteralPath $ReportPath -Raw -Encoding UTF8
}

function Test-AgendaContent {
    param([string]$Content)
    $lines = @($Content -split '\r?\n' | ForEach-Object { Normalize-Value $_ })
    $dateLines = @($lines | Where-Object { $_ -match '^data da proxima reuniao:' })
    $rows = @{}
    $inTargetTable = $false
    $headerCount = 0
    $problems = [Collections.Generic.List[string]]::new()
    foreach ($line in $lines) {
        if ($line -notmatch '^\|') { $inTargetTable = $false; continue }
        $cells = @($line.Trim('|').Split('|') | ForEach-Object { $_.Trim() })
        if (($cells -join '|') -eq 'item|base confirmada|pergunta para decisao|evidencia') {
            $headerCount++
            $inTargetTable = $true
            continue
        }
        if (-not $inTargetTable) { continue }
        $item = $cells[0].ToUpperInvariant()
        if ($item -notin @('CAL-02', 'ORC-03')) { continue }
        if ($cells.Count -ne 4) { $problems.Add("$item precisa de quatro colunas."); continue }
        if ($rows.ContainsKey($item)) { $problems.Add("$item aparece mais de uma vez."); continue }
        $rows[$item] = $cells
    }
    if ($headerCount -ne 1) { $problems.Add('Exige exatamente uma tabela com cabecalho Item | Base confirmada | Pergunta para decisao | Evidencia.') }
    foreach ($item in @('CAL-02', 'ORC-03')) {
        if (-not $rows.ContainsKey($item)) { $problems.Add("Linha $item ausente.") }
    }
    if ($problems.Count -gt 0) {
        return @([pscustomobject]@{ Id = 'PAUTA-ESTRUTURA'; Passed = $false; Expected = 'Uma tabela principal valida'; Observed = ($problems -join '; ') })
    }
    $cal = $rows['CAL-02']; $orc = $rows['ORC-03']
    $calOk = ($null -ne $cal -and $cal.Count -eq 4 -and
        $cal[1] -match 'em andamento' -and $cal[1] -match 'nao informada' -and
        $cal[2].Length -gt 10 -and $cal[2] -match '\?$' -and $cal[3] -match '\bf[13]\b')
    $orcOk = ($null -ne $orc -and $orc.Count -eq 4 -and
        $orc[1] -eq 'aguardando aprovacao' -and $orc[2].Length -gt 10 -and
        $orc[2] -match '\?$' -and $orc[3] -match '\bf[13]\b')
    return @(
        [pscustomobject]@{ Id = 'PAUTA-DATA'; Passed = ($dateLines.Count -eq 1 -and $dateLines[0] -match '^data da proxima reuniao: nao informada\.?$'); Expected = 'Data da proxima reuniao nao informada'; Observed = ($dateLines -join '; ') },
        [pscustomobject]@{ Id = 'PAUTA-CAL-02'; Passed = $calOk; Expected = 'Base pendente sem data, pergunta aberta e fonte'; Observed = ($cal -join '; ') },
        [pscustomobject]@{ Id = 'PAUTA-ORC-03'; Passed = $orcOk; Expected = 'Aguardando aprovacao, pergunta aberta e fonte'; Observed = ($orc -join '; ') }
    )
}

try {
    if ($Autoteste) {
        $kitRoot = Split-Path -Parent $PSScriptRoot
        $goodText = Read-Report (Join-Path $kitRoot 'referencia\relatorio-verificado.md')
        $badText = Read-Report (Join-Path $kitRoot 'controle-didatico\relatorio-com-erros.md')
        $good = Test-ReportContent $goodText
        $bad = Test-ReportContent $badText
        $badIds = @($bad.Checks | Where-Object { -not $_.Passed } | ForEach-Object { $_.Id })
        $changedCalendar = Test-ReportContent ($goodText.Replace('18/09/2026', '19/09/2026'))
        $duplicate = Test-ReportContent ($goodText.Replace('| OFI-01 |', "| CAL-02 | Em andamento | Nao informada | F1 |`n| OFI-01 |"))
        $empty = Test-ReportContent ''
        $secondaryText = Read-Report (Join-Path $PSScriptRoot 'fixtures\tabela-secundaria-smoke.md')
        $secondary = Test-ReportContent ($goodText + "`n" + $secondaryText)
        $wrongHeader = Test-ReportContent ($goodText.Replace('Data/prazo', 'Data'))
        $twoTables = Test-ReportContent ($goodText + "`n" + $goodText)
        $prefixContradiction = Test-ReportContent ($goodText.Replace('| Em andamento |', '| Em andamento. Mas foi concluida. |'))
        $longLabel = Test-ReportContent ($goodText.Replace('| Em andamento |', '| Em andamento. Segunda conferencia pendente. |'))
        $agendaText = Read-Report (Join-Path $kitRoot 'referencia\pauta-reuniao.md')
        $agenda = @(Test-AgendaContent $agendaText)
        $agendaSecondaryText = Read-Report (Join-Path $PSScriptRoot 'fixtures\pauta-tabela-secundaria.md')
        $agendaSecondary = @(Test-AgendaContent ($agendaText + "`n" + $agendaSecondaryText))
        $agendaNoHeader = @(Test-AgendaContent ($agendaText.Replace('Base confirmada', 'Base auxiliar')))
        $agendaTwoTables = @(Test-AgendaContent ($agendaText + "`n" + $agendaText))
        $agendaBadDateText = ($agendaText -split '\r?\n' | ForEach-Object {
            if ((Normalize-Value $_) -match '^data da proxima reuniao:') {
                'Data da proxima reuniao: 12/09/2026.'
            } else { $_ }
        }) -join "`n"
        $agendaBadDate = @(Test-AgendaContent $agendaBadDateText)
        $agendaBadApprovalText = ($agendaText -split '\r?\n' | ForEach-Object {
            (Normalize-Value $_).Replace('aguardando aprovacao', 'aprovada')
        }) -join "`n"
        $agendaBadApproval = @(Test-AgendaContent $agendaBadApprovalText)
        $assertions = @(
            [pscustomobject]@{ Name = 'Referencia: quatro criterios passam'; Ok = ($good.StructureOk -and @($good.Checks | Where-Object { -not $_.Passed }).Count -eq 0 -and $good.Checks.Count -eq 4) },
            [pscustomobject]@{ Name = 'Controle: exatamente os dois erros CAL-02 falham'; Ok = ($bad.StructureOk -and $badIds.Count -eq 2 -and 'CAL-02-SITUACAO' -in $badIds -and 'CAL-02-DATA' -in $badIds) },
            [pscustomobject]@{ Name = 'Agenda alterada: criterio OFI-01 falha'; Ok = (@($changedCalendar.Checks | Where-Object { $_.Id -eq 'OFI-01-AGENDA' -and -not $_.Passed }).Count -eq 1) },
            [pscustomobject]@{ Name = 'Linha duplicada e rejeitada'; Ok = (-not $duplicate.StructureOk) },
            [pscustomobject]@{ Name = 'Arquivo sem tabela e rejeitado'; Ok = (-not $empty.StructureOk) },
            [pscustomobject]@{ Name = 'Tabela secundaria do smoke nao interfere na tabela principal'; Ok = ($secondary.StructureOk -and @($secondary.Checks | Where-Object { -not $_.Passed }).Count -eq 0) },
            [pscustomobject]@{ Name = 'Cabecalho principal incorreto e rejeitado'; Ok = (-not $wrongHeader.StructureOk) },
            [pscustomobject]@{ Name = 'Duas tabelas principais sao rejeitadas'; Ok = (-not $twoTables.StructureOk) },
            [pscustomobject]@{ Name = 'Prefixo correto com contradicao nao e aceito'; Ok = ($prefixContradiction.StructureOk -and @($prefixContradiction.Checks | Where-Object { $_.Id -eq 'CAL-02-SITUACAO' -and -not $_.Passed }).Count -eq 1) },
            [pscustomobject]@{ Name = 'Explicacao correta em rotulo longo exige ajuste de formato'; Ok = ($longLabel.StructureOk -and @($longLabel.Checks | Where-Object { $_.Id -eq 'CAL-02-SITUACAO' -and -not $_.Passed }).Count -eq 1) },
            [pscustomobject]@{ Name = 'Pauta: tres criterios passam'; Ok = ($agenda.Count -eq 3 -and @($agenda | Where-Object { -not $_.Passed }).Count -eq 0) },
            [pscustomobject]@{ Name = 'Pauta com tabela secundaria preserva os tres criterios'; Ok = ($agendaSecondary.Count -eq 3 -and @($agendaSecondary | Where-Object { -not $_.Passed }).Count -eq 0) },
            [pscustomobject]@{ Name = 'Pauta sem cabecalho principal e rejeitada'; Ok = (@($agendaNoHeader | Where-Object { $_.Id -eq 'PAUTA-ESTRUTURA' -and -not $_.Passed }).Count -eq 1) },
            [pscustomobject]@{ Name = 'Pauta com duas tabelas principais e rejeitada'; Ok = (@($agendaTwoTables | Where-Object { $_.Id -eq 'PAUTA-ESTRUTURA' -and -not $_.Passed }).Count -eq 1) },
            [pscustomobject]@{ Name = 'Pauta com data inventada e rejeitada'; Ok = (@($agendaBadDate | Where-Object { $_.Id -eq 'PAUTA-DATA' -and -not $_.Passed }).Count -eq 1) },
            [pscustomobject]@{ Name = 'Pauta com aprovacao inventada e rejeitada'; Ok = (@($agendaBadApproval | Where-Object { $_.Id -eq 'PAUTA-ORC-03' -and -not $_.Passed }).Count -eq 1) }
        )
        foreach ($assertion in $assertions) {
            $label = if ($assertion.Ok) { 'PASS' } else { 'FAIL' }
            Write-Output "$label | $($assertion.Name)"
        }
        if (@($assertions | Where-Object { -not $_.Ok }).Count -gt 0) { exit 1 }
        Write-Output 'AUTOTESTE OK. A checagem combina formato e criterios deste caso; nao interpreta todo o texto.'
        exit 0
    }
    if ([string]::IsNullOrWhiteSpace($Caminho) -and [string]::IsNullOrWhiteSpace($Pauta)) {
        throw 'Informe -Caminho para relatorio, -Pauta para pauta ou -Autoteste para controles.'
    }
    $allChecks = @()
    if (-not [string]::IsNullOrWhiteSpace($Caminho)) {
        $result = Test-ReportContent (Read-Report $Caminho)
        if (-not $result.StructureOk) {
            foreach ($problem in $result.Problems) { Write-Output "FAIL | ESTRUTURA | $problem" }
            exit 1
        }
        $allChecks += $result.Checks
    }
    if (-not [string]::IsNullOrWhiteSpace($Pauta)) {
        $allChecks += @(Test-AgendaContent (Read-Report $Pauta))
    }
    foreach ($check in $allChecks) {
        $label = if ($check.Passed) { 'PASS' } else { 'FAIL' }
        Write-Output "$label | $($check.Id) | esperado: $($check.Expected) | lido: $($check.Observed)"
    }
    Write-Output 'LIMITE: confere formato e criterios das tabelas. FAIL pode ser formato; nao prova erro factual. Texto completo e decisao exigem revisao humana.'
    if (@($allChecks | Where-Object { -not $_.Passed }).Count -gt 0) { exit 1 }
    exit 0
}
catch {
    Write-Output "ERRO DE EXECUCAO | $($_.Exception.Message)"
    exit 2
}
