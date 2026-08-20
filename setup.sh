#!/bin/bash

# Mac Setup Script - Install all required applications and tools

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

fancy_echo() {
  local type="$1"
  local msg="$2"
  
  case "$type" in
    "info")    echo -e "${BLUE}➜${NC} $msg" ;;
    "success") echo -e "${GREEN}✓${NC} $msg" ;;
    "skip")    echo -e "${YELLOW}⊘${NC} $msg" ;;
    "error")   echo -e "${RED}✗${NC} $msg" ;;
    *)         echo -e "$msg" ;;
  esac
}

append_to_zshrc() {
  local text="$1"
  local zshrc="$HOME/.zshrc"

  # Create .zshrc if it doesn't exist
  touch "$zshrc"

  if ! grep -Fqs "$text" "$zshrc"; then
    printf "\n%s\n" "$text" >> "$zshrc"
    fancy_echo "success" "Added to $zshrc: $text"
  else
    fancy_echo "skip" "'$text' already exists in $zshrc"
  fi
}

brew_tap() {
  local tap="$1"
  if brew tap | grep -Fqx "$tap"; then
    fancy_echo "skip" "tap $tap already added, skipping"
  else
    fancy_echo "info" "Tapping $tap..."
    brew tap "$tap"
  fi
}

brew_install() {
  local formula="$1"
  if brew list --formula "$formula" &>/dev/null; then
    fancy_echo "skip" "$formula already installed, skipping"
  else
    fancy_echo "info" "Installing $formula..."
    brew install "$formula"
    fancy_echo "success" "$formula installed"
  fi
}

# Optional formula install: doesn't hard-fail the whole script (e.g. private taps
# that require org membership you may not have on every machine)
brew_install_optional() {
  local formula="$1"
  if brew list --formula "$formula" &>/dev/null; then
    fancy_echo "skip" "$formula already installed, skipping"
  else
    fancy_echo "info" "Installing $formula (optional)..."
    if brew install "$formula" 2>/dev/null; then
      fancy_echo "success" "$formula installed"
    else
      fancy_echo "skip" "$formula not available (private tap/no access?), skipping"
    fi
  fi
}

brew_cask_install() {
  local cask="$1"
  local app_name="${2:-$cask}"
  if brew list --cask "$cask" &>/dev/null || [ -d "/Applications/$app_name.app" ]; then
    fancy_echo "skip" "$cask already installed, skipping"
  else
    fancy_echo "info" "Installing $cask..."
    brew install --cask "$cask"
    fancy_echo "success" "$cask installed"
  fi
}


# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
  fancy_echo "info" "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fancy_echo "success" "Homebrew installed"
else
  fancy_echo "success" "Homebrew is already installed"
fi

# Applications to install via Homebrew
fancy_echo "info" "Installing applications..."

# --- CLI Tools ---
brew_install zsh
brew_install node
brew_install python@3.14
brew_install uv
brew_install coreutils
brew_install jq
brew_install gh
brew_install htop
brew_install telnet

# --- Dev / Infra CLI Tools ---
brew_install golang-migrate
brew_install grpcurl
brew_install protobuf
brew_install redis
brew_install postgresql@18
brew_install zookeeper
brew_install sbt
brew_install maven
brew_install golangci-lint
brew_install k9s
brew_install kaf
brew_install kcat
brew_tap telepresenceio/telepresence
brew_install telepresence-oss
brew_cask_install gcloud-cli "Google Cloud SDK"

# --- Internal / Chotot tooling (requires Carousell org GitHub access) ---
brew_tap carousell/ct-homebrew
brew_install_optional ctprompt

# --- AI Coding Assistants (CLI) ---
brew_cask_install claude-code "Claude Code"
brew_cask_install codex "Codex"
brew_tap anomalyco/tap
brew_install anomalyco/tap/opencode
# NOTE: gemini-cli formula is deprecated upstream (removal ~2026-12-18).
# Replacement going forward is the antigravity-cli cask.
brew_install gemini-cli
brew_cask_install antigravity-cli "Antigravity CLI"

# --- AI Coding Assistants (Desktop / IDE) ---
brew_cask_install opencode-desktop "OpenCode"
brew_cask_install conductor "Conductor"
brew_cask_install antigravity "Antigravity"

# Applications (casks)
brew_cask_install orbstack "OrbStack"
brew_cask_install slack "Slack"
brew_cask_install google-chrome "Google Chrome"
brew_cask_install cloudflare-warp "Cloudflare WARP"
brew_cask_install iterm2 "iTerm"
brew_cask_install visual-studio-code "Visual Studio Code"
brew_cask_install jetbrains-idea "IntelliJ IDEA"
brew_cask_install goland "GoLand"
brew_cask_install datagrip "DataGrip"
brew_cask_install notion "Notion"
brew_cask_install lens "Lens"
brew_cask_install freelens "Freelens"
brew_cask_install dia "Dia"
brew_cask_install drawio "draw.io"
brew_cask_install obsidian "Obsidian"

# Databases / API tooling
brew_cask_install docker-desktop "Docker"
brew_cask_install postman "Postman"
brew_cask_install dbeaver-community "DBeaver"
brew_cask_install another-redis-desktop-manager "Another Redis Desktop Manager"

# System utilities
brew_cask_install stats "Stats"
brew_cask_install logi-options-plus "Logi Options+"
brew_cask_install teamviewer "TeamViewer"
# Amphetamine (keep-awake utility) is Mac App Store only, install manually:
# https://apps.apple.com/app/amphetamine/id937984704

# Communication
brew_cask_install zalo "Zalo"

fancy_echo "success" "Applications installed"

# Install fonts
fancy_echo "info" "Installing fonts..."
brew_cask_install font-fira-code
brew_cask_install font-fira-code-nerd-font

# Install Vietnamese input method
fancy_echo "info" "Installing GoTiengViet..."
brew_cask_install gotiengviet "GoTiengViet"

# Setup oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  fancy_echo "info" "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fancy_echo "success" "oh-my-zsh installed"
else
  fancy_echo "success" "oh-my-zsh is already installed"
fi

# Set zsh as default shell
if [ "$SHELL" != "/bin/zsh" ]; then
  fancy_echo "info" "Setting zsh as default shell..."
  chsh -s /bin/zsh
  fancy_echo "success" "Default shell set to zsh"
fi

# Setup oh-my-zsh theme (robbyrussell, the oh-my-zsh default)
fancy_echo "info" "Setting up oh-my-zsh theme..."
if grep -q 'ZSH_THEME="robbyrussell"' ~/.zshrc; then
  fancy_echo "skip" "Theme already set to robbyrussell, skipping"
else
  # Remove old theme setting if present
  sed -i '' '/^ZSH_THEME=/d' ~/.zshrc
  append_to_zshrc 'ZSH_THEME="robbyrussell"'
  fancy_echo "success" "Theme set to robbyrussell"
fi

# Setup Dracula theme for iTerm2 (requires manual import)
fancy_echo "info" "Downloading Dracula theme for iTerm2..."
if [ ! -d "$HOME/dracula-iterm" ]; then
  git clone https://github.com/dracula/iterm.git ~/dracula-iterm
  fancy_echo "success" "Dracula theme downloaded to ~/dracula-iterm"
  echo "To apply: iTerm2 > Preferences > Profiles > Colors > Color Presets > Import > Select Dracula.itermcolors"
else
  fancy_echo "success" "Dracula theme already downloaded"
fi

# --- AI Coding Assistant configuration ---
fancy_echo "info" "Configuring AI coding assistant plugins..."

if command -v claude &>/dev/null; then
  fancy_echo "info" "Adding Claude Code marketplaces..."
  claude plugin marketplace add anthropics/claude-plugins-official 2>/dev/null || true
  claude plugin marketplace add carousell/ct-claude-plugins 2>/dev/null || true
  claude plugin marketplace add carousell/ct-builder-os 2>/dev/null || true

  fancy_echo "info" "Installing Claude Code plugins..."
  claude plugin install superpowers@claude-plugins-official 2>/dev/null || true
  claude plugin install data-analytic@ct-claude-plugins 2>/dev/null || true
  claude plugin install builder-os-platform@carousell-ct-builder-os 2>/dev/null || true
  fancy_echo "success" "Claude Code plugins configured"
else
  fancy_echo "skip" "Claude Code CLI not found, skipping plugin setup"
fi

if command -v opencode &>/dev/null; then
  mkdir -p "$HOME/.config/opencode"
  if [ ! -f "$HOME/.config/opencode/opencode.json" ]; then
    cp "$(dirname "${BASH_SOURCE[0]}")/configs/opencode.global.json" "$HOME/.config/opencode/opencode.json"
    fancy_echo "success" "Copied global OpenCode config to ~/.config/opencode/opencode.json"
  else
    fancy_echo "skip" "~/.config/opencode/opencode.json already exists, skipping"
  fi
else
  fancy_echo "skip" "OpenCode CLI not found, skipping config setup"
fi

fancy_echo "success" "AI coding assistant setup complete"

# Final message
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Setup complete! 🎉${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo "Next steps:"
echo "1. Open iTerm2 and set Dracula theme (Preferences > Profiles > Colors > Import ~/dracula-iterm/Dracula.itermcolors)"
echo "2. Set Fira Code / Fira Code Nerd Font in iTerm2 (Preferences > Profiles > Text > Font)"
echo "3. Restart your terminal to apply all changes"
echo "4. Run 'claude', 'opencode', 'codex' and 'gcloud auth login' once each to complete their interactive login"
echo "5. Configure each application as needed"
echo ""
