# MacOS Setup Script

A comprehensive and automated setup script for macOS, designed to install essential CLI tools, GUI applications, and customize the development environment (Zsh, oh-my-zsh, iTerm2 themes).

## 🚀 Overview

This script automates the tedious process of setting up a new Mac. It uses **Homebrew** to manage installations and includes custom helper functions to ensure a smooth, idempotent installation process (skipping already installed tools).

## 📦 What's Included?

### CLI Tools
- **Zsh**: The default shell for macOS.
- **Node.js**: JavaScript runtime.
- **Python 3**: General-purpose programming language.
- **uv**: An extremely fast Python package manager.

### GUI Applications (via Homebrew Cask)
- **OrbStack**: Fast, light, and simple Docker & Linux environment.
- **Slack**: Team communication.
- **Google Chrome**: Web browser.
- **Cloudflare WARP**: Safer and faster internet.
- **iTerm2**: Terminal emulator.
- **Visual Studio Code**: Code editor.
- **IntelliJ IDEA**: Java & Scala IDE.
- **Notion**: Note-taking and organization.
- **Lens**: Kubernetes IDE.
- **Dia**: Diagramming tool.
- **GoTiengViet**: Vietnamese input method.

### Environment & Themes
- **oh-my-zsh**: Framework for managing Zsh configuration.
- **Agnoster Theme**: A beautiful Zsh theme.
- **Fira Code**: Monospaced font with programming ligatures.
- **Dracula for iTerm2**: Essential color scheme for the terminal.

### Helper Functions
- `fancy_echo`: Beautiful command-line output with icons (Info, Success, Skip, Error).
- `brew_install` & `brew_cask_install`: Intelligent wrappers that check if a package is already installed (including checking `/Applications`) before fetching it.
- `append_to_zshrc`: Safely appends configuration to `~/.zshrc` without duplicates.

## 🛠️ Usage

### 1. Clone the repository
```bash
git clone https://github.com/flynn3103/mac-setup.git
cd mac-setup
```

### 2. Make the script executable
```bash
chmod +x setup.sh
```

### 3. Run the script
```bash
./setup.sh
```

## 📝 Post-Installation Steps

After the script completes, there are a few manual steps required to finalize the visual setup:

1. **iTerm2 Dracula Theme**: 
   - Open iTerm2.
   - Go to `Preferences > Profiles > Colors`.
   - Select `Color Presets... > Import`.
   - Choose `~/dracula-iterm/Dracula.itermcolors`.
   - Select `Dracula` from the preset list.

2. **Fira Code Font**:
   - In iTerm2, go to `Preferences > Profiles > Text`.
   - Click `Change Font` and select **Fira Code**.

3. **Restart Terminal**:
   - Close and reopen your terminal to apply the Zsh theme and configurations.
