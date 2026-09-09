#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/avvo-na/embervim.git}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.config/nvim}"
BACKUP_SUFFIX="${BACKUP_SUFFIX:-$(date +%Y%m%d-%H%M%S)}"
LOCAL_BIN_DIR="${LOCAL_BIN_DIR:-$HOME/.local/bin}"

WITH_OPTIONAL=0
SKIP_BOOTSTRAP=0
FORCE_OVERWRITE=0

log() {
  printf '[embervim] %s\n' "$*"
}

warn() {
  printf '[embervim] warning: %s\n' "$*" >&2
}

die() {
  printf '[embervim] error: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<EOF
Usage: $(basename "$0") [options]

Bootstrap embervim on Ubuntu by installing Neovim, core CLI tools, and this config.

Options:
  --with-optional   Install optional tools like lazygit, silicon, and pnpm
  --skip-bootstrap  Skip the headless Neovim bootstrap step
  --force           Replace an existing non-git config without prompting
  --help            Show this help text

Environment overrides:
  REPO_URL          Git URL to clone from
  INSTALL_DIR       Neovim config target directory
  LOCAL_BIN_DIR     Directory for local helper symlinks
EOF
}

require_ubuntu() {
  [[ -r /etc/os-release ]] || die "cannot detect operating system"
  # shellcheck disable=SC1091
  source /etc/os-release

  [[ "${ID:-}" == "ubuntu" ]] || die "this installer currently supports Ubuntu only"
  UBUNTU_CODENAME="${VERSION_CODENAME:-}"
  [[ -n "$UBUNTU_CODENAME" ]] || die "could not detect Ubuntu codename"
}

require_sudo() {
  command -v sudo >/dev/null 2>&1 || die "sudo is required"
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --with-optional)
        WITH_OPTIONAL=1
        ;;
      --skip-bootstrap)
        SKIP_BOOTSTRAP=1
        ;;
      --force)
        FORCE_OVERWRITE=1
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        die "unknown option: $1"
        ;;
    esac
    shift
  done
}

apt_install() {
  sudo apt-get install -y "$@"
}

apt_package_exists() {
  apt-cache show "$1" >/dev/null 2>&1
}

install_base_packages() {
  log "installing base packages"
  sudo apt-get update
  apt_install software-properties-common ca-certificates curl git unzip tar gzip build-essential ripgrep fd-find xclip nodejs npm
}

install_optional_packages() {
  [[ "$WITH_OPTIONAL" -eq 1 ]] || return 0

  log "installing optional packages"
  if apt_package_exists lazygit; then
    apt_install lazygit
  else
    warn "lazygit package not available in this Ubuntu release"
  fi

  if apt_package_exists silicon; then
    apt_install silicon
  else
    warn "silicon package not available in this Ubuntu release"
  fi

  if ! command -v pnpm >/dev/null 2>&1; then
    sudo npm install -g pnpm
  fi
}

detect_nvim_arch() {
  case "$(dpkg --print-architecture)" in
    amd64)
      NVIM_DEB_ARCH="x86_64"
      ;;
    arm64)
      NVIM_DEB_ARCH="arm64"
      ;;
    *)
      die "unsupported architecture: $(dpkg --print-architecture)"
      ;;
  esac
}

install_latest_neovim() {
  detect_nvim_arch

  if command -v nvim >/dev/null 2>&1; then
    local current_version
    current_version="$(nvim --version | head -n1 || true)"
    log "existing Neovim detected: ${current_version:-unknown}"
  fi

  local temp_dir deb_url deb_path
  temp_dir="$(mktemp -d)"
  deb_url="https://github.com/neovim/neovim-releases/releases/latest/download/nvim-linux-${NVIM_DEB_ARCH}.deb"
  deb_path="${temp_dir}/nvim-linux-${NVIM_DEB_ARCH}.deb"

  log "downloading latest stable Neovim release"
  curl -fsSL --retry 3 --retry-delay 2 -o "$deb_path" "$deb_url"

  log "installing Neovim package"
  sudo apt-get install -y "$deb_path"

  rm -rf "$temp_dir"
}

ensure_fd_symlink() {
  mkdir -p "$LOCAL_BIN_DIR"

  if command -v fd >/dev/null 2>&1; then
    return 0
  fi

  if command -v fdfind >/dev/null 2>&1; then
    ln -sf "$(command -v fdfind)" "$LOCAL_BIN_DIR/fd"
    log "linked fd to Ubuntu's fdfind binary"
  fi
}

backup_existing_config() {
  [[ -e "$INSTALL_DIR" ]] || return 0

  if [[ -d "$INSTALL_DIR/.git" ]]; then
    return 0
  fi

  if [[ "$FORCE_OVERWRITE" -ne 1 ]]; then
    die "$INSTALL_DIR already exists and is not a git checkout; rerun with --force to back it up automatically"
  fi

  local backup_dir
  backup_dir="${INSTALL_DIR}.backup-${BACKUP_SUFFIX}"
  mv "$INSTALL_DIR" "$backup_dir"
  log "backed up existing config to $backup_dir"
}

clone_or_update_config() {
  mkdir -p "$(dirname "$INSTALL_DIR")"

  if [[ -d "$INSTALL_DIR/.git" ]]; then
    log "updating existing embervim checkout"
    git -C "$INSTALL_DIR" remote set-url origin "$REPO_URL"
    git -C "$INSTALL_DIR" pull --ff-only origin HEAD || warn "git pull failed; leaving existing checkout in place"
    return 0
  fi

  if [[ -e "$INSTALL_DIR" ]]; then
    die "$INSTALL_DIR exists but is not usable"
  fi

  log "cloning embervim into $INSTALL_DIR"
  git clone "$REPO_URL" "$INSTALL_DIR"
}

bootstrap_neovim() {
  [[ "$SKIP_BOOTSTRAP" -eq 0 ]] || return 0

  log "bootstrapping plugins and Mason tools"
  if ! PATH="$LOCAL_BIN_DIR:$PATH" nvim --headless "+Lazy! sync" "+MasonToolsInstallSync" "+qa"; then
    warn "headless bootstrap did not complete cleanly"
    warn "open nvim manually and run :Lazy! sync and :MasonToolsInstallSync"
  fi
}

print_summary() {
  log "installation complete"
  printf '\n'
  printf 'Next steps:\n'
  printf '  export PATH="%s:$PATH"\n' "$LOCAL_BIN_DIR"
  printf '  nvim\n'
}

main() {
  parse_args "$@"
  require_ubuntu
  require_sudo

  log "detected Ubuntu ${UBUNTU_CODENAME}"

  install_base_packages
  install_optional_packages
  install_latest_neovim
  ensure_fd_symlink
  backup_existing_config
  clone_or_update_config
  bootstrap_neovim
  print_summary
}

main "$@"
