#!/bin/bash

set -e

# Pacman packages
packages=(
  dolphin
  dunst
  grim
  hyprland
  kitty
  polkit-kde-agent
  qt5-wayland
  qt6-wayland
  slurp
  rofi-wayland
  stow
  waybar
  hyprpaper
  go
  hyprlock
  zsh
  git
  neovim
  starship
  tmux
  zoxide
  fzf
)

echo "=== Installing pacman packages ==="
for pkg in "${packages[@]}"; do
  if pacman -Qi "$pkg" &>/dev/null; then
    echo "✓ $pkg is already installed"
  else
    echo "→ Installing $pkg"
    sudo pacman -S --noconfirm "$pkg"
  fi
done

# Install Rust if not already installed
if ! command -v rustc &>/dev/null; then
  echo "→ Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
  echo "✓ Rust is already installed"
fi

# Install yay if not already installed
if ! command -v yay &>/dev/null; then
  echo "→ Installing yay (AUR helper)..."
  sudo pacman -S --needed --noconfirm git base-devel
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
  cd "$tmpdir/yay-bin"
  makepkg -si --noconfirm
  cd -
  rm -rf "$tmpdir"
else
  echo "✓ yay is already installed"
fi

# AUR packages
aur_packages=(
  swayosd-git
  hypridle
  wlogout
  hyprshot
  brave-bin
)

echo "=== Installing AUR packages ==="
for aur_pkg in "${aur_packages[@]}"; do
  if yay -Qi "$aur_pkg" &>/dev/null; then
    echo "✓ $aur_pkg is already installed"
  else
    echo "→ Installing $aur_pkg via yay"
    yay -S --noconfirm "$aur_pkg"
  fi
done

# Link dotfiles if available
DOTFILES_DIR="$HOME/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
  echo "→ Linking dotfiles..."
  cd "$DOTFILES_DIR"
  stow */
else
  echo "⚠️ Dotfiles directory not found at $DOTFILES_DIR"
fi

# Change shell to Zsh if not already
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "→ Changing default shell to Zsh..."
  chsh -s /bin/zsh
  echo "ℹ️ Please log out and log back in for the shell change to take effect."
else
  echo "✓ Default shell is already Zsh"
fi

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
  echo "→ Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✓ Homebrew is already installed"
fi

echo "✅ Full setup complete!"
