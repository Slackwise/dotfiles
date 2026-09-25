#!/usr/bin/env bash
# Idempotent setup script for this dotfiles repo.
# Detects Windows / macOS / Linux (Ubuntu, Arch, CachyOS, Gentoo, Guix) and installs
# the tools needed to use these dotfiles, then wires up bashrc and git config.
set -uo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$script_dir"

log()     { echo "==> $*"; }
warn()    { echo "!!  $*" >&2; }
command_exists() { command -v "$1" >/dev/null 2>&1; }

# DETECT OPERATING SYSTEM ----------------------------------------------------
detected_os="Unknown"
distro_id=""

case "$(uname -s 2>/dev/null)" in
  Linux*)
    detected_os="Linux"
    if [[ -f /etc/os-release ]]; then
      # shellcheck disable=SC1091
      distro_id="$(. /etc/os-release && echo "${ID:-}")"
    fi
    ;;
  Darwin*)
    detected_os="macOS"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    detected_os="Windows"
    ;;
  *)
    if [[ "${OS:-}" == "Windows_NT" ]]; then
      detected_os="Windows"
    fi
    ;;
esac

log "Detected OS: $detected_os${distro_id:+ ($distro_id)}"

# INSTALL NODE.JS -------------------------------------------------------------
install_node_windows() {
  if command_exists nvs; then
    log "nvs already installed."
    return
  fi
  if ! command_exists winget; then
    warn "winget not found; cannot install nvs. Install it manually: https://github.com/jasongin/nvs"
    return
  fi
  log "Installing nvs (Node Version Switcher) via winget..."
  winget install --exact --id jasongin.nvs
}

install_node_linux() {
  if command_exists node || command_exists nodejs; then
    log "Node.js already installed."
    return
  fi

  case "$distro_id" in
    ubuntu|debian)
      log "Installing Node.js via apt..."
      sudo apt-get update && sudo apt-get install -y nodejs npm
      ;;
    arch|cachyos|manjaro)
      log "Installing Node.js via pacman..."
      sudo pacman -Sy --needed --noconfirm nodejs npm
      ;;
    gentoo)
      log "Installing Node.js via emerge..."
      sudo emerge --ask=n net-libs/nodejs
      ;;
    guix)
      log "Installing Node.js via guix..."
      guix install node
      ;;
    *)
      warn "Unrecognized Linux distro ('$distro_id'); install Node.js manually."
      ;;
  esac
}

install_node_macos() {
  if command_exists node; then
    log "Node.js already installed."
    return
  fi
  if ! command_exists brew; then
    warn "Homebrew not found; cannot install node. Install it manually: https://nodejs.org/"
    return
  fi
  log "Installing Node.js via Homebrew..."
  brew install node
}

case "$detected_os" in
  Windows) install_node_windows ;;
  Linux)   install_node_linux ;;
  macOS)   install_node_macos ;;
  *)       warn "Unknown OS; skipping Node.js installation." ;;
esac

# INSTALL NBB (GLOBAL NPM PACKAGE) -------------------------------------------
if command_exists nbb; then
  log "nbb already installed."
elif command_exists npm; then
  log "Installing nbb globally via npm..."
  npm install -g nbb
else
  warn "npm not found; cannot install nbb."
fi

# GIT CONFIG ------------------------------------------------------------------
if command_exists git; then
  log "Running git/git-config.sh..."
  bash "$dotfiles_dir/git/git-config.sh"
else
  warn "git not found; skipping git config setup."
fi

# BASHRC INSTALL --------------------------------------------------------------
if [[ "${Sw_BASHRC_READ:-}" == "true" ]]; then
  log "Personal bashrc already active in this session; skipping bashrc-install.sh."
else
  log "Running bash/bashrc-install.sh..."
  bash "$dotfiles_dir/bash/bashrc-install.sh"
fi

# PERSONAL SCRIPTS REPO (slackwise only) --------------------------------------
if [[ "${USER:-${USERNAME:-}}" == "slackwise" ]]; then
  scripts_dir="$dotfiles_dir/scripts"

  if [[ -d "$scripts_dir/.git" ]]; then
    log "scripts repo already cloned."
  else
    if command_exists git; then
      log "Cloning https://github.com/Slackwise/scripts into scripts/..."
      git clone https://github.com/Slackwise/scripts "$scripts_dir"
    else
      warn "git not found; cannot clone scripts repo."
    fi
  fi

  if [[ -f "$scripts_dir/git-scripts-install.pl" ]]; then
    if command_exists perl; then
      log "Running scripts/git-scripts-install.pl..."
      perl "$scripts_dir/git-scripts-install.pl"
    else
      warn "perl not found; cannot run git-scripts-install.pl."
    fi
  fi
fi

log "Setup complete! Your dotfiles are 100% ready to go."
