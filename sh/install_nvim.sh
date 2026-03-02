#!/bin/bash

set -e

# ============================================================
# install_nvim.sh
# 下载 Neovim AppImage 并安装到指定目录，同时 clone nvim 配置
# 用法:
#   ./install_nvim.sh [-p ssh|https] [INSTALL_DIR] [CONFIG_DIR]
# 选项:
#   -p ssh    使用 SSH 协议克隆（默认，需要私钥）
#   -p https  使用 HTTPS 协议克隆（无私钥机器）
# 默认值:
#   INSTALL_DIR = $HOME/.local/bin
#   CONFIG_DIR  = $HOME/.config/nvim
# ============================================================

PROTOCOL="ssh"

while getopts ":p:" opt; do
    case "$opt" in
        p)
            case "$OPTARG" in
                ssh|https) PROTOCOL="$OPTARG" ;;
                *)
                    echo "Error: -p 只接受 ssh 或 https" >&2
                    exit 1
                    ;;
            esac
            ;;
        :)
            echo "Error: -$OPTARG 需要一个参数" >&2
            exit 1
            ;;
        \?)
            echo "Error: 未知选项 -$OPTARG" >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND - 1))

INSTALL_DIR="${1:-$HOME/.local/bin}"
CONFIG_DIR="${2:-$HOME/.config/nvim}"

if [ "$PROTOCOL" = "ssh" ]; then
    NVIM_REPO="git@github.com:LinHeLurking/nvim.config.git"
else
    NVIM_REPO="https://github.com/LinHeLurking/nvim.config.git"
fi
NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
NVIM_BIN="$INSTALL_DIR/nvim"

echo "==> Install dir : $INSTALL_DIR"
echo "==> Config dir  : $CONFIG_DIR"
echo "==> Appimage URL: $NVIM_APPIMAGE_URL"
echo "==> Config repo : $NVIM_REPO"
echo ""

# ------------------------------------------------------------
# 1. 下载 AppImage
# ------------------------------------------------------------
echo "[1/3] Downloading Neovim AppImage..."
mkdir -p "$INSTALL_DIR"

if command -v curl >/dev/null 2>&1; then
    curl -fL --progress-bar "$NVIM_APPIMAGE_URL" -o "$NVIM_BIN"
elif command -v wget >/dev/null 2>&1; then
    wget -q --show-progress "$NVIM_APPIMAGE_URL" -O "$NVIM_BIN"
else
    echo "Error: curl or wget is required." >&2
    exit 1
fi

chmod +x "$NVIM_BIN"
echo "    Neovim installed at: $NVIM_BIN"

# ------------------------------------------------------------
# 2. 将 INSTALL_DIR 加入 PATH 提示（如尚未在 PATH 中）
# ------------------------------------------------------------
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
    echo ""
    echo "Note: $INSTALL_DIR is not in your PATH."
    echo "      Add the following line to your shell profile (~/.bashrc / ~/.zshrc):"
    echo "        export PATH=\"$INSTALL_DIR:\$PATH\""
fi

# ------------------------------------------------------------
# 3. Clone 配置仓库
# ------------------------------------------------------------
echo ""
echo "[2/3] Cloning nvim config (depth=1) to $CONFIG_DIR..."

if [ -d "$CONFIG_DIR" ]; then
    echo "    Directory $CONFIG_DIR already exists."
    read -r -p "    Remove and re-clone? [y/N] " answer
    case "$answer" in
        [yY][eE][sS]|[yY])
            rm -rf "$CONFIG_DIR"
            ;;
        *)
            echo "    Skipped config clone."
            ;;
    esac
fi

if [ ! -d "$CONFIG_DIR" ]; then
    git clone --depth=1 "$NVIM_REPO" "$CONFIG_DIR"
    echo "    Config cloned to: $CONFIG_DIR"
fi

# ------------------------------------------------------------
# 4. 验证安装，处理 FUSE 缺失
# ------------------------------------------------------------
echo ""
echo "[3/3] Verifying installation..."

NVIM_VERSION_OUTPUT=$("$NVIM_BIN" --version 2>&1)
NVIM_VERSION_EXIT=$?

if [ $NVIM_VERSION_EXIT -eq 0 ]; then
    echo "$NVIM_VERSION_OUTPUT" | head -1
    echo ""
    echo "Done."
else
    # 检查是否为 FUSE 错误
    if echo "$NVIM_VERSION_OUTPUT" | grep -qi "fuse\|libfuse\|AppImage"; then
        echo "    Detected FUSE error. Extracting AppImage instead..."

        APPIMAGE_DIR="$INSTALL_DIR/nvim_appimage"
        APPIMAGE_FILE="$APPIMAGE_DIR/nvim.appimage"

        mkdir -p "$APPIMAGE_DIR"
        mv "$NVIM_BIN" "$APPIMAGE_FILE"
        chmod +x "$APPIMAGE_FILE"

        echo "    Extracting AppImage to $APPIMAGE_DIR/squashfs-root ..."
        (cd "$APPIMAGE_DIR" && "$APPIMAGE_FILE" --appimage-extract >/dev/null)

        APPRUN="$APPIMAGE_DIR/squashfs-root/AppRun"
        if [ ! -f "$APPRUN" ]; then
            echo "Error: AppRun not found at $APPRUN after extraction." >&2
            exit 1
        fi

        ln -sf "$APPRUN" "$NVIM_BIN"
        echo "    Symlink created: $NVIM_BIN -> $APPRUN"

        "$NVIM_BIN" --version 2>/dev/null | head -1 || true
        echo ""
        echo "Done."
    else
        echo "Warning: nvim --version failed with unexpected error:" >&2
        echo "$NVIM_VERSION_OUTPUT" >&2
    fi
fi
