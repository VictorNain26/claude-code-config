# sync.ps1
# Copie l'inverse : ~/.claude/ vers ce repo. A lancer apres avoir modifie
# une config locale, avant de commit/push.
#
# Usage : .\sync.ps1
$ErrorActionPreference = 'Stop'
$src = Join-Path $env:USERPROFILE '.claude'
$dst = $PSScriptRoot

if (-not (Test-Path $src)) {
    Write-Error "$src introuvable"
    exit 1
}

# Top-level files
foreach ($f in @('CLAUDE.md','settings.json')) {
    $s = Join-Path $src $f
    if (Test-Path $s) {
        Copy-Item $s $dst -Force
        Write-Host "  Sync -> $dst\$f"
    }
}

# Sub-directories
foreach ($d in @('hooks','commands','agents','rules','scripts')) {
    $s = Join-Path $src $d
    $t = Join-Path $dst $d
    if (Test-Path $s) {
        if (Test-Path $t) { Remove-Item $t -Recurse -Force }
        Copy-Item $s $dst -Recurse -Force
        Write-Host "  Sync -> $t\"
    }
}

Write-Host ""
Write-Host "Sync terminee." -ForegroundColor Green
Write-Host "Verifie : git status puis git diff avant de commit."
