#!/usr/bin/env bash
# Runs Proton's official installer and persists the installation directory in PATH.
set -euo pipefail

fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }

case "${1:-}" in
  --help)
    printf '%s\n' \
      'Usage: bash proton/install-proton-pass-cli.sh' \
      'Runs the official Proton Pass CLI installer; safe to rerun.' \
      'Optional: PROTON_PASS_CLI_INSTALL_DIR and PROTON_PASS_CLI_INSTALL_CHANNEL.' \
      'Unix requires bash, curl, jq and sha256sum or shasum.' \
      'Windows requires Git Bash and built-in Windows PowerShell.'
    exit 0
    ;;
esac
[[ $# -eq 0 ]] || fail 'Unexpected arguments. Use --help for usage.'

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) platform=windows ;;
  Darwin*|Linux*) platform=unix ;;
  *) fail 'Unsupported OS; Proton supports Windows, macOS and Linux.' ;;
esac

if [[ "$platform" == windows ]]; then
  command -v cygpath >/dev/null || fail 'cygpath is required; run this script from Git Bash.'
  windows_root="${SYSTEMROOT:-${SystemRoot:-${WINDIR:-}}}"
  [[ -n "$windows_root" ]] || fail 'Cannot locate Windows PowerShell: SystemRoot/WINDIR is unset.'
  powershell="$(cygpath -u "$windows_root")/System32/WindowsPowerShell/v1.0/powershell.exe"
  [[ -x "$powershell" ]] || fail "Windows PowerShell not found: $powershell"

  # Passing configuration through the environment avoids shell interpolation in PowerShell.
  if [[ -n "${PROTON_PASS_CLI_INSTALL_DIR:-}" ]]; then
    export PROTON_PASS_CLI_INSTALL_DIR
    PROTON_PASS_CLI_INSTALL_DIR="$(cygpath -aw "$PROTON_PASS_CLI_INSTALL_DIR")"
  fi
  "$powershell" -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$(cat <<'POWERSHELL'
$ErrorActionPreference = 'Stop'
try {
    if (-not $env:PROTON_PASS_CLI_INSTALL_DIR) {
        $env:PROTON_PASS_CLI_INSTALL_DIR = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'Programs\ProtonPass'
    }
    $directory = [IO.Path]::GetFullPath($env:PROTON_PASS_CLI_INSTALL_DIR)
    $env:PROTON_PASS_CLI_INSTALL_DIR = $directory
    $temporary = Join-Path ([IO.Path]::GetTempPath()) ('proton-pass-cli-' + [guid]::NewGuid())
    New-Item -ItemType Directory -Path $temporary | Out-Null
    try {
        $installer = Join-Path $temporary 'install.ps1'
        Invoke-WebRequest -UseBasicParsing -Uri 'https://proton.me/download/pass-cli/install.ps1' -OutFile $installer
        & $installer
        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
            throw "Proton installer failed with exit code $LASTEXITCODE."
        }
    } finally {
        Remove-Item -LiteralPath $temporary -Recurse -Force
    }
    & (Join-Path $directory 'pass-cli.exe') --version
    if ($LASTEXITCODE -ne 0) { throw 'Installed pass-cli failed verification.' }
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $entries = @($userPath -split ';' | Where-Object { $_ })
    if ($entries -notcontains $directory) {
        [Environment]::SetEnvironmentVariable('Path', (($entries + $directory) -join ';'), 'User')
    }
    $env:Path = $directory + ';' + $env:Path
    & pass-cli --version
    if ($LASTEXITCODE -ne 0) { throw 'pass-cli failed PATH verification.' }
    Write-Host "Installed in $directory"
} catch {
    Write-Error $_ -ErrorAction Continue
    exit 1
}
POWERSHELL
)"
  printf '%s\n' 'Close and reopen your terminal application (including VS Code) to refresh PATH for PowerShell, Git Bash and nbb.'
else
  for dependency in curl jq; do
    command -v "$dependency" >/dev/null || fail "Install $dependency before running Proton's installer."
  done
  if ! command -v sha256sum >/dev/null && ! command -v shasum >/dev/null; then
    fail "Install sha256sum or shasum before running Proton's installer."
  fi
  export PROTON_PASS_CLI_INSTALL_DIR="${PROTON_PASS_CLI_INSTALL_DIR:-$HOME/.local/bin}"
  mkdir -p "$PROTON_PASS_CLI_INSTALL_DIR"
  PROTON_PASS_CLI_INSTALL_DIR="$(cd "$PROTON_PASS_CLI_INSTALL_DIR" && pwd -P)"
  curl -fsSL https://proton.me/download/pass-cli/install.sh | bash
  "$PROTON_PASS_CLI_INSTALL_DIR/pass-cli" --version

  append_block() {
    local file="$1" block="$2"
    if [[ -e "$file" ]] && grep -Fqx -- "$block" "$file"; then
      return
    fi
    mkdir -p "$(dirname "$file")"
    printf '\n%s\n' "$block" >> "$file"
    printf 'Updated %s\n' "$file"
  }

  # Quote literal paths for startup files, including spaces, apostrophes and dollar signs.
  shell_directory="'${PROTON_PASS_CLI_INSTALL_DIR//\'/\'\"\'\"\'}'"
  path_block="case \":\$PATH:\" in *:$shell_directory:*) ;; *) export PATH=$shell_directory:\"\$PATH\" ;; esac # Proton Pass CLI"
  login_file="$HOME/.profile"
  for file in "$HOME/.bash_profile" "$HOME/.bash_login" "$HOME/.profile"; do
    if [[ -e "$file" ]]; then
      login_file="$file"
      break
    fi
  done
  for file in "$HOME/.bashrc" "$login_file" "$HOME/.zshrc" "$HOME/.zprofile"; do
    append_block "$file" "$path_block"
  done

  ps_directory="'${PROTON_PASS_CLI_INSTALL_DIR//\'/\'\'}'"
  ps_block="\$protonPassCliDir = $ps_directory; if ((\$env:PATH -split [IO.Path]::PathSeparator) -notcontains \$protonPassCliDir) { \$env:PATH = \$protonPassCliDir + [IO.Path]::PathSeparator + \$env:PATH } # Proton Pass CLI"
  append_block "${XDG_CONFIG_HOME:-$HOME/.config}/powershell/profile.ps1" "$ps_block"

  export PATH="$PROTON_PASS_CLI_INSTALL_DIR:$PATH"
  pass-cli --version
  printf 'Installed in %s\n' "$PROTON_PASS_CLI_INSTALL_DIR"
  printf '%s\n' 'Start a new Bash, Zsh or PowerShell session to refresh PATH for that shell and nbb.'
fi

printf '%s\n' 'The installer cannot change PATH in its already-running parent shell.'
