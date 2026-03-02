# nvim.config

My personal Neovim configuration.

## Quick Install

Run the following command to download Neovim and set up this config automatically:

**HTTPS** (no SSH key required):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/LinHeLurking/nvim.config/main/sh/install_nvim.sh) -p https
```

**SSH**:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/LinHeLurking/nvim.config/main/sh/install_nvim.sh) -p ssh
```

The script will:

1. Download the latest Neovim AppImage to `~/.local/bin/nvim`
2. Clone this config to `~/.config/nvim`

### Options

```
./install_nvim.sh [-p ssh|https] [INSTALL_DIR] [CONFIG_DIR]

  -p ssh    Clone via SSH (default, requires SSH key)
  -p https  Clone via HTTPS (no SSH key needed)

  INSTALL_DIR  Where to install nvim binary (default: ~/.local/bin)
  CONFIG_DIR   Where to clone the config (default: ~/.config/nvim)
```

### Add nvim to PATH

If `~/.local/bin` is not already in your `PATH`, add this to your shell profile (`~/.bashrc` or `~/.zshrc`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```
