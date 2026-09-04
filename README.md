# macinit 🍏

> One-liner bootstrapping and onboarding script for macOS.

Set up a fresh Mac with all your favorite GUI applications, essential CLI tools, personal macOS system defaults, and your development environment in a single command.

---

## 🚀 Quickstart for a Fresh Mac

Open Terminal and run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jiminu/macinit/main/bootstrap.sh)"
```

Or clone the repository and run manually:

```bash
git clone https://github.com/jiminu/macinit.git ~/.macinit
cd ~/.macinit
./bootstrap.sh
```

### What it does
1. **Xcode Command Line Tools**: Checks and triggers installation if missing.
2. **Homebrew**: Installs Homebrew and sets up `PATH` automatically for Apple Silicon and Intel.
3. **App & Tool Installation**: Installs all GUI apps and tools declared in **`Brewfile`** via `brew bundle`.
4. **macOS Developer Defaults**:
   - **Dark Mode**: Automatically activates Dark Mode.
   - **Keyboard**: Fast key repeat rate (`KeyRepeat = 2`, `InitialKeyRepeat = 15`).
   - **Trackpad**:
     - Tap to click enabled.
     - Three-finger drag enabled (`TrackpadThreeFingerDrag`).
   - **Dock**:
     - Automatically hide Dock.
     - Hide recent applications in Dock.
   - **Finder**:
     - Show all filename extensions.
     - Search current folder by default (`FXDefaultSearchScope = SCev`).
     - Preferred column view by default (`FXPreferredViewStyle = clmv`).
5. **Selfishell Integration**: Prompts to seamlessly run [selfishell](https://github.com/jiminu/selfishell) installation with `--setup` for a complete Zsh/Neovim developer environment.

---

## 🔄 Updating Your Brewfile

Whenever you install new tools or apps and want to sync your configuration:

```bash
brew bundle dump --force --file=./Brewfile
git add Brewfile
git commit -m "chore: update Brewfile"
git push
```

---

## 📂 Project Structure

- [bootstrap.sh](file:///Users/edowon-welabs/code/macos/bootstrap.sh): Main onboarding entry point
- [Brewfile](file:///Users/edowon-welabs/code/macos/Brewfile): Declarative list of Homebrew formulae and casks
