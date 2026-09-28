# vim: set ts=4 sw=4:
# Sourced via $PROFILE on every new PowerShell session (see Install-Profile.ps1).

if (-not $env:DOTFILES) {
    $env:DOTFILES = Join-Path $HOME 'src\dotfiles'
}

$psCommandsDir = Join-Path $env:DOTFILES 'powershell\Commands'
$psModulesDir = Join-Path $env:DOTFILES 'powershell\Modules'

if (($env:Path -split ';') -notcontains $psCommandsDir) {
    $env:Path = "$psCommandsDir;$env:Path"
}

if (($env:PSModulePath -split ';') -notcontains $psModulesDir) {
    $env:PSModulePath = "$psModulesDir;$env:PSModulePath"
}

if (($env:PATHEXT -split ';') -notcontains '.PS1') {
    $env:PATHEXT = "$env:PATHEXT;.PS1"
}
