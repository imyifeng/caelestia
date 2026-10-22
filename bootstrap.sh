#!/usr/bin/env bash
# caelestia 魔改版——全新 Arch/CachyOS 复现脚本
#
# 用法（在全新系统上）：
#   sudo pacman -S --needed git
#   git clone https://github.com/imyifeng/caelestia.git ~/Projects/caelestia/caelestia
#   cd ~/Projects/caelestia/caelestia && ./bootstrap.sh [--sddm]
#
# --sddm  同时安装 caelestia-sddm-locklike-git（登录主题 + 壁纸同步脚本，cli.json postHook 依赖）
#
# 脚本做的事：装 paru → 部署 overrides/（cli.json 的 dots.url 指向本 fork，
# 必须先于 caelestia install 就位）→ 构建安装 caelestia-shell-imyifeng →
# caelestia install（按 manifest 装 dots 和全部依赖包，可选组件启用 zed,nvim）。
# 需要在交互终端运行，过程中会要几次 sudo 密码。

set -euo pipefail

DOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_REPO="https://github.com/imyifeng/caelestia-shell.git"
SHELL_DIR="$(dirname "$DOTS_DIR")/caelestia-shell"
CFG="$HOME/.config/caelestia"

log()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m警告:\033[0m %s\n' "$*"; }

# ---- 0. 预检 ----
[[ $(id -u) -ne 0 ]] || { echo "不要用 root 运行"; exit 1; }
command -v pacman >/dev/null || { echo "仅支持 Arch 系发行版"; exit 1; }
if pacman -Q uwsm &>/dev/null; then
    warn "检测到 uwsm：SDDM 会默认选中字母序靠前的 uwsm 会话接管整个会话（Clash Party 双自启的根源）。强烈建议：sudo pacman -Rns uwsm"
fi
sudo -v || exit 1

# ---- 1. 基础工具与 AUR helper ----
log "安装基础工具"
sudo pacman -S --needed --noconfirm git base-devel zsh fish gettext

if ! command -v paru >/dev/null; then
    log "安装 paru"
    rm -rf /tmp/paru-bin
    git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
    (cd /tmp/paru-bin && makepkg -si --noconfirm)
fi

# ---- 2. 部署用户覆盖文件（cli.json 必须先于 caelestia install 存在）----
log "部署用户覆盖文件（已有文件先备份为 *.bak.<时间戳>）"
deploy() { # deploy <仓库内路径> <目标路径> <权限>
    local src="$DOTS_DIR/$1" dst="$2" mode="$3"
    mkdir -p "$(dirname "$dst")"
    if [[ -e $dst ]] && ! cmp -s "$src" "$dst"; then
        cp "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"
    fi
    install -m "$mode" "$src" "$dst"
    echo "  $1 -> $dst"
}
deploy overrides/hypr-vars.lua           "$CFG/hypr-vars.lua"                    644
deploy overrides/hypr-user.lua           "$CFG/hypr-user.lua"                    644
deploy overrides/shell.json              "$CFG/shell.json"                       644
deploy overrides/cli.json                "$CFG/cli.json"                         644
deploy overrides/logout.sh               "$CFG/logout.sh"                        755
deploy overrides/user-config.zsh         "$CFG/user-config.zsh"                  644
deploy overrides/environment-d-ime.conf  "$HOME/.config/environment.d/ime.conf"  644
deploy overrides/gtkrc-2.0               "$HOME/.gtkrc-2.0"                      644
deploy overrides/gtk-3.0-settings.ini    "$HOME/.config/gtk-3.0/settings.ini"    644
deploy overrides/gtk-4.0-settings.ini    "$HOME/.config/gtk-4.0/settings.ini"    644
deploy overrides/mihomo-party.desktop    "$HOME/.config/autostart/mihomo-party.desktop" 644

# ---- 3. 构建、安装魔改 shell（先于 caelestia install，防止官方包顶掉）----
log "安装 shell 的 AUR 依赖"
paru -S --needed quickshell-git qt6-m3shapes-git caelestia-cli

if [[ ! -d $SHELL_DIR ]]; then
    log "克隆 shell 仓库"
    git clone "$SHELL_REPO" "$SHELL_DIR"
fi

log "构建 caelestia-shell-imyifeng（makepkg -s 自动补齐仓库依赖）"
(cd "$SHELL_DIR" && git pull --ff-only || true)
rm -rf "$SHELL_DIR/aur/src" "$SHELL_DIR/aur/pkg"
(cd "$SHELL_DIR/aur" && makepkg -sf --noconfirm)

log "安装 caelestia-shell-imyifeng（提示与官方 caelestia-shell 冲突时选 yes 替换）"
sudo pacman -U "$SHELL_DIR"/aur/caelestia-shell-imyifeng-*.pkg.tar.zst

# ---- 4. caelestia install：从 fork 拉取 dots，装齐 manifest 全部依赖 ----
log "运行 caelestia install（dots.url 已指向 fork；可选组件启用 zed,nvim）"
caelestia install --noconfirm --enable-components zed,nvim

# ---- 5. uwsm 保险（正常不应走到，见预检警告）----
if pacman -Q uwsm &>/dev/null; then
    log "uwsm 在场，应用 Clash Party 双自启保险 mask"
    systemctl --user mask 'app-mihomo\x2dparty@autostart.service' || true
fi

# ---- 6. 可选：SDDM 主题 ----
if [[ ${1:-} == "--sddm" ]]; then
    log "安装 SDDM 主题"
    paru -S --needed caelestia-sddm-locklike-git
fi

# ---- 7. 收尾清单 ----
log "完成。剩余手动步骤："
cat <<'EOF'
  1. sudo systemctl enable sddm          # 若未启用显示管理器
  2. 重启后登录时选择普通 "Hyprland" 会话（永远不要安装 uwsm）
  3. 若未加 --sddm 且需要登录主题/壁纸同步：paru -S caelestia-sddm-locklike-git
     可选免密（换主题不输密码）：
       sudo visudo -f /etc/sudoers.d/caelestia-sddm
       <你的用户名> ALL=(root) NOPASSWD: /usr/share/sddm/themes/caelestia/scripts/sync.sh
  4. Clash Party 不走包管理器，需从 GitHub releases 手动安装（autostart 文件已就位）
  5. 验证：Clash Party 静默启动且托盘有图标、fcitx5 输入法可用、Super+T 是 kitty、Super+W 是 chrome
EOF
