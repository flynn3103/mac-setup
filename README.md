# MacOS Setup Script

A comprehensive and automated setup script for macOS, designed to install essential CLI tools, GUI applications, AI coding assistants, and customize the development environment (Zsh, oh-my-zsh, iTerm2 themes).

## 🚀 Overview

This script automates the tedious process of setting up a new Mac. It uses **Homebrew** to manage installations and includes custom helper functions to ensure a smooth, idempotent installation process (skipping already installed tools).

## 📦 What's Included?

### CLI Tools
- **Zsh**: The default shell for macOS.
- **Node.js**: JavaScript runtime.
- **Python 3.14**: General-purpose programming language.
- **uv**: An extremely fast Python package manager.
- **coreutils**, **jq**, **gh** (GitHub CLI), **htop**, **telnet**

### Dev / Infra CLI Tools
- **golang-migrate**: Database migrations.
- **grpcurl**, **protobuf**: gRPC tooling.
- **redis**, **postgresql@18**, **zookeeper**: local databases/coordination for dev.
- **sbt**, **maven**: Scala/Java build tools.
- **golangci-lint**: Go linter.
- **k9s**: Kubernetes terminal UI.
- **kaf**, **kcat**: Kafka CLI producers/consumers.
- **telepresence-oss** (tap `telepresenceio/telepresence`): local-to-cluster dev tunneling.
- **Google Cloud SDK** (`gcloud-cli` cask).
- **ctprompt** (tap `carousell/ct-homebrew`, optional/internal): Chotot-internal tool, requires Carousell org GitHub access — the script skips it gracefully if unavailable.

### AI Coding Assistants
- **Claude Code** (`claude-code` cask) — Anthropic's terminal coding agent.
- **Codex CLI** (`codex` cask) — OpenAI's terminal coding agent.
- **OpenCode CLI** (`anomalyco/tap/opencode` formula) + **OpenCode Desktop** (`opencode-desktop` cask).
- **Gemini CLI** (`gemini-cli` formula — ⚠️ deprecated upstream, scheduled for removal ~2026-12-18; replacement is the `antigravity-cli` cask, also installed).
- **Conductor** (`conductor` cask) — Claude Code session/worktree parallelization UI.
- **Antigravity** (`antigravity` cask) + **Antigravity IDE**.

The script also bootstraps each tool's config where possible:
- **Claude Code**: adds the marketplaces `anthropics/claude-plugins-official`, `carousell/ct-claude-plugins`, `carousell/ct-builder-os`, then installs/enables the plugins `superpowers@claude-plugins-official`, `data-analytic@ct-claude-plugins`, and `builder-os-platform@carousell-ct-builder-os`. Additional per-project marketplaces/plugins (e.g. `data-agent-kit-starter-pack`) can be added the same way as needed.
- **OpenCode**: copies `configs/opencode.global.json` (checked into this repo, no secrets) to `~/.config/opencode/opencode.json`. It configures the default model, the `opencode-claude-auth` and `opencode-goal-plugin` plugins, and the `plan`/`build`/`general`/`explore` agent presets.
- **Codex CLI**: ships with a built-in curated plugin marketplace (`openai-curated-remote`, including `superpowers`, `notion`, etc.) — no extra setup needed out of the box. Project trust levels (`~/.codex/config.toml`) are machine/local-path specific and intentionally not scripted.

> Secrets, tokens, and MCP server credentials are **never** committed to this repo. If a tool needs them (e.g. an internal MCP server), configure them locally after running the script.

### GUI Applications (via Homebrew Cask)
- **OrbStack**: Fast, light, and simple Docker & Linux environment.
- **Slack**: Team communication.
- **Google Chrome**: Web browser.
- **Cloudflare WARP**: Safer and faster internet.
- **iTerm2**: Terminal emulator.
- **Visual Studio Code**: Code editor.
- **IntelliJ IDEA**, **GoLand**, **DataGrip**: JetBrains IDEs (Java/Scala, Go, databases).
- **Notion**: Note-taking and organization.
- **Obsidian**: Local-first note-taking.
- **Lens** / **Freelens**: Kubernetes IDEs.
- **Dia**: Diagramming tool.
- **draw.io**: Diagramming tool.
- **GoTiengViet**: Vietnamese input method.

### Databases / API Tooling
- **Docker Desktop**
- **Postman**
- **DBeaver Community**
- **Another Redis Desktop Manager**

### System Utilities & Communication
- **Stats**: Menu bar system monitor.
- **Logi Options+**: Logitech mouse/keyboard configuration.
- **TeamViewer**: Remote access.
- **Zalo**: Messaging app.
- **Amphetamine** (Mac App Store only, not scripted — [install manually](https://apps.apple.com/app/amphetamine/id937984704)): keep-awake utility.

### Environment & Themes
- **oh-my-zsh**: Framework for managing Zsh configuration.
- **robbyrussell Theme**: The oh-my-zsh default theme (currently in use).
- **Fira Code** + **Fira Code Nerd Font**: Monospaced fonts with programming ligatures / icon glyphs.
- **Dracula for iTerm2**: Essential color scheme for the terminal (downloaded, manual import required).

### Helper Functions
- `fancy_echo`: Beautiful command-line output with icons (Info, Success, Skip, Error).
- `brew_install` & `brew_cask_install`: Intelligent wrappers that check if a package is already installed (including checking `/Applications`) before fetching it.
- `brew_install_optional`: Like `brew_install`, but doesn't fail the whole script if unavailable (used for internal/private-tap tools).
- `brew_tap`: Adds a Homebrew tap if not already added.
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

After the script completes, there are a few manual steps required to finalize the setup:

1. **iTerm2 Dracula Theme**:
   - Open iTerm2.
   - Go to `Preferences > Profiles > Colors`.
   - Select `Color Presets... > Import`.
   - Choose `~/dracula-iterm/Dracula.itermcolors`.
   - Select `Dracula` from the preset list.

2. **Fira Code Font**:
   - In iTerm2, go to `Preferences > Profiles > Text`.
   - Click `Change Font` and select **Fira Code** (or **FiraCode Nerd Font** for icon glyphs).

3. **AI CLI logins**:
   - Run `claude`, `opencode`, and `codex` once each and complete their interactive login flow.
   - Run `gcloud auth login` for Google Cloud SDK.

4. **Restart Terminal**:
   - Close and reopen your terminal to apply the Zsh theme and configurations.

5. **Configure each application as needed.**
