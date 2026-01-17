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

# CLI tools
brew_install zsh
brew_install node
brew_install python3
brew_install uv

# Applications (casks)
brew_cask_install orbstack "OrbStack"
brew_cask_install slack "Slack"
brew_cask_install google-chrome "Google Chrome"
brew_cask_install cloudflare-warp "Cloudflare WARP"
brew_cask_install iterm2 "iTerm"
brew_cask_install visual-studio-code "Visual Studio Code"
brew_cask_install jetbrains-idea "IntelliJ IDEA"
brew_cask_install notion "Notion"
brew_cask_install lens "Lens"
brew_cask_install dia "Dia"

fancy_echo "success" "Applications installed"

# Install fonts
fancy_echo "info" "Installing fonts..."
brew_cask_install font-fira-code

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

# Setup oh-my-zsh theme (agnoster)
fancy_echo "info" "Setting up oh-my-zsh theme..."
if grep -q 'ZSH_THEME="agnoster"' ~/.zshrc; then
  fancy_echo "skip" "Theme already set to agnoster, skipping"
else
  # Remove old theme setting if present
  sed -i '' '/^ZSH_THEME=/d' ~/.zshrc
  # Use append_to_zshrc or direct echo
  append_to_zshrc 'ZSH_THEME="agnoster"'
  fancy_echo "success" "Theme set to agnoster"
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

# Install Vietnamese input method
fancy_echo "info" "Installing GoTiengViet..."
brew_cask_install gotiengviet "GoTiengViet"

# Final message
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Setup complete! 🎉${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo "Next steps:"
echo "1. Open iTerm2 and set Dracula theme (Preferences > Profiles > Colors > Import ~/dracula-iterm/Dracula.itermcolors)"
echo "2. Set Fira Code font in iTerm2 (Preferences > Profiles > Text > Font)"
echo "3. Restart your terminal to apply all changes"
echo "4. Configure each application as needed"
echo ""
