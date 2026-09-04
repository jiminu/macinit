#!/usr/bin/env bash
# ==============================================================================
# macinit - bootstrap.sh
# Automated setup script for macOS
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="${SCRIPT_DIR}/Brewfile"
REPO_RAW_URL="https://raw.githubusercontent.com/jiminu/macinit/main"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

success() {
    printf "${GREEN}[OK]${NC} %s\n" "$1"
}

warn() {
    printf "${YELLOW}[WARN]${NC} %s\n" "$1"
}

error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1" >&2
}

# 1. macOS check
if [[ "$(uname)" != "Darwin" ]]; then
    error "This script is only intended for macOS."
    exit 1
fi

info "Starting macinit setup..."

# 2. Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Xcode Command Line Tools dialog prompted. Press Enter after installation completes."
    read -r
else
    success "Xcode Command Line Tools already installed."
fi

# 3. Homebrew
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Set PATH for Apple Silicon / Intel
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    success "Homebrew already installed."
fi

# Ensure brew is available in current shell session
if ! command -v brew &>/dev/null; then
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

info "Updating Homebrew..."
brew update

# 4. Prepare Brewfile (download from GitHub if not found locally)
TEMP_BREWFILE=""
if [[ ! -f "${BREWFILE}" ]]; then
    info "Local Brewfile not found. Downloading from remote repository..."
    TEMP_BREWFILE="$(mktemp -t Brewfile.XXXXXX)"
    curl -fsSL "${REPO_RAW_URL}/Brewfile" -o "${TEMP_BREWFILE}"
    BREWFILE="${TEMP_BREWFILE}"
fi

# 5. Install bundle from Brewfile
info "Installing packages and applications from Brewfile..."
brew bundle --file="${BREWFILE}"
success "Brewfile packages installed successfully!"

# Clean up temp file if created
if [[ -n "${TEMP_BREWFILE}" && -f "${TEMP_BREWFILE}" ]]; then
    rm -f "${TEMP_BREWFILE}"
fi

# 6. Apply macOS Developer System Defaults
echo ""
read -r -p "Apply macOS developer defaults (fast key repeat, tap to click, show extensions)? [Y/n] " apply_defaults
apply_defaults="${apply_defaults:-Y}"
if [[ "$apply_defaults" =~ ^[Yy]$ ]]; then
    info "Configuring macOS defaults..."

    # Fast key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Trackpad: tap to click
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # Finder: show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Restart Finder to apply changes
    killall Finder 2>/dev/null || true
    success "macOS defaults applied."
fi

# 7. Chain Selfishell Installation
echo ""
read -r -p "Install and set up selfishell environment? [Y/n] " install_selfishell
install_selfishell="${install_selfishell:-Y}"
if [[ "$install_selfishell" =~ ^[Yy]$ ]]; then
    info "Installing selfishell CLI and running setup (--setup)..."
    curl -fsSL https://raw.githubusercontent.com/jiminu/selfishell/main/install.sh | bash -s -- --setup
    success "selfishell setup completed."
fi

echo ""
success "=================================================="
success "  macinit setup complete! Enjoy your new Mac 🎉"
success "=================================================="
