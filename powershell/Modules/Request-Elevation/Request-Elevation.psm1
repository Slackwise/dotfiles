<#
.SYNOPSIS
Re-launches a script elevated (as Administrator) if not already running elevated.

.DESCRIPTION
Checks whether the current process is an Administrator. If not, starts a new
elevated PowerShell process running -ScriptPath (via UAC prompt) and exits the
current (non-elevated) process. If already elevated, returns immediately.

.PARAMETER ScriptPath
Full path to the script to re-launch elevated. Typically $PSCommandPath.

.PARAMETER ScriptArgs
Additional arguments to pass through to the elevated script invocation.
#>
function Request-Elevation {
    param(
        [Parameter(Mandatory)][string]$ScriptPath,
        [string[]]$ScriptArgs = @()
    )

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    if ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        return
    }

    $psExe = (Get-Process -Id $PID).Path
    $argumentList = @('-NoProfile', '-File', $ScriptPath) + $ScriptArgs
    Start-Process -FilePath $psExe -Verb RunAs -ArgumentList $argumentList
    exit
}

Export-ModuleMember -Function Request-Elevation
