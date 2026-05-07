# install.ps1
# Copie la config versionnee de ce repo vers ~/.claude/.
# Idempotent : ecrase les fichiers existants apres backup.
#
# Usage : .\install.ps1
$ErrorActionPreference = 'Stop'
$src = $PSScriptRoot
$dst = Join-Path $env:USERPROFILE '.claude'

if (-not (Test-Path $dst)) {
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
}

# Backup settings.json existant si present
$settingsDst = Join-Path $dst 'settings.json'
if (Test-Path $settingsDst) {
    $bk = "$settingsDst.bak-install-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $settingsDst $bk
    Write-Host "Backup pre-install : $bk" -ForegroundColor DarkGray
}

# Top-level files
foreach ($f in @('CLAUDE.md','settings.json')) {
    $s = Join-Path $src $f
    if (Test-Path $s) {
        Copy-Item $s $dst -Force
        Write-Host "  Copie -> $dst\$f"
    }
}

# Sub-directories
foreach ($d in @('hooks','commands','agents','rules','scripts')) {
    $s = Join-Path $src $d
    $t = Join-Path $dst $d
    if (Test-Path $s) {
        if (Test-Path $t) { Remove-Item $t -Recurse -Force }
        Copy-Item $s $dst -Recurse -Force
        Write-Host "  Copie -> $t\"
    }
}

Write-Host ""
Write-Host "Install terminee." -ForegroundColor Green
Write-Host "Redemarre Claude Code (exit + relance) pour activer."
