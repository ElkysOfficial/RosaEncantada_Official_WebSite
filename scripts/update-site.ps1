# ====================================================================
# Rosa Encantada — Substituicao em lote de dominio e WhatsApp
# Uso (a partir da raiz do projeto): .\scripts\update-site.ps1
# ====================================================================

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

# ----- Valores antigos -> novos -----
$replacements = @(
    @{ Old = 'https://rosaencantada.com.br'; New = 'https://green-hippopotamus-490496.hostingersite.com' }
    @{ Old = 'rosaencantada.com.br';         New = 'green-hippopotamus-490496.hostingersite.com' }
    @{ Old = '5500000000000';                New = '5531986977393' }
    @{ Old = '(00) 00000-0000';              New = '(31) 98697-7393' }
)

# ----- Extensoes de arquivos a processar -----
$includeExt = @('.html', '.css', '.js', '.xml', '.json', '.txt', '.md', '.webmanifest')
$includeNamed = @('.htaccess')

# ----- Coleta arquivos -----
$files = Get-ChildItem -Path $root -Recurse -File | Where-Object {
    ($includeExt -contains $_.Extension.ToLower()) -or ($includeNamed -contains $_.Name.ToLower())
} | Where-Object {
    $_.FullName -notmatch '\\\.git\\' -and
    $_.FullName -notmatch '\\node_modules\\' -and
    $_.Name -ne 'update-site.ps1' -and
    $_.Name -ne 'convert-images.ps1'
}

Write-Host ""
Write-Host "Rosa Encantada - atualizando $($files.Count) arquivos..." -ForegroundColor Magenta
Write-Host ""

$totalChanges = 0

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    if ($null -eq $content) { continue }

    $original = $content
    $fileChanges = 0

    foreach ($r in $replacements) {
        $count = ([regex]::Matches($content, [regex]::Escape($r.Old))).Count
        if ($count -gt 0) {
            $content = $content.Replace($r.Old, $r.New)
            $fileChanges += $count
        }
    }

    if ($content -ne $original) {
        # Preserva BOM/sem-BOM apropriadamente: usa UTF8NoBOM
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)

        $rel = $file.FullName.Substring($root.Length + 1)
        Write-Host ("  OK  {0,-40} ({1} alteracoes)" -f $rel, $fileChanges) -ForegroundColor Green
        $totalChanges += $fileChanges
    }
}

Write-Host ""
Write-Host "Concluido. Total de substituicoes: $totalChanges" -ForegroundColor Magenta
Write-Host ""
Write-Host "Resumo das substituicoes aplicadas:" -ForegroundColor Cyan
foreach ($r in $replacements) {
    Write-Host ("  '{0}' -> '{1}'" -f $r.Old, $r.New)
}
Write-Host ""
