<#
.SYNOPSIS
Idempotently symlinks $PROFILE to this repo's powershell/Profile.ps1.

.DESCRIPTION
PowerShell equivalent of bash/bashrc-install.sh: makes $PROFILE a symlink into
this repo so Profile.ps1's PATH/PSModulePath setup runs on every new session.
#>

Import-Module (Join-Path $PSScriptRoot 'Modules\Request-Elevation\Request-Elevation.psm1') -Force
Request-Elevation -ScriptPath $PSCommandPath

$profileTarget = Join-Path $PSScriptRoot 'Profile.ps1'
$profilePath = $PROFILE
$profileBackup = "$profilePath.sys"

function Test-SymlinkTo {
    param([string]$Path, [string]$Target)
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    return $item -and $item.LinkType -eq 'SymbolicLink' -and ($item.Target -contains $Target)
}

try {
    if (Test-SymlinkTo -Path $profilePath -Target $profileTarget) {
        Write-Host "$profilePath already symlinked to $profileTarget."
        return
    }

    $profileDir = Split-Path -Parent $profilePath
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }

    if (Test-Path -LiteralPath $profilePath) {
        if (Test-Path -LiteralPath $profileBackup) {
            Remove-Item -LiteralPath $profilePath -Force
        } else {
            Move-Item -LiteralPath $profilePath -Destination $profileBackup
            Write-Host "Backed up existing profile to $profileBackup."
        }
    }

    try {
        New-Item -ItemType SymbolicLink -Path $profilePath -Target $profileTarget -ErrorAction Stop | Out-Null
        Write-Host "Symlinked $profilePath -> $profileTarget."
    } catch {
        Write-Error "Failed to create symlink. Run as Administrator or enable Developer Mode. $_"
    }
} finally {
    # Keeps the console open when double-clicked/run via right-click so output is readable.
    if ([Environment]::UserInteractive) {
        Read-Host 'Press Enter to close'
    }
}
