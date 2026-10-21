> [!NOTE]
> 本仓库是 [caelestia-dots/caelestia](https://github.com/caelestia-dots/caelestia) 的**个人魔改版**（fork），维护者：imyifeng。
> 本文档描述魔改后的实际状态；上游通用文档请看原仓库。配套仓库：[caelestia-shell-imyifeng](https://github.com/imyifeng/caelestia-shell)（桌面 shell，含中文翻译与打包）、[caelestia-sddm](https://github.com/imyifeng/caelestia-sddm)（登录界面）。

# caelestia（魔改版 dotfiles）

基于 Caelestia dotfiles 的个人配置。安装仍通过 `caelestia` CLI：`paru -S caelestia-cli && caelestia install`，按 [manifest.toml](/manifest.toml) 中的组件清单复制文件、安装软件包。

## 与上游的差异（魔改清单）

| 领域 | 上游 | 本仓库 | 相关文件 |
| --- | --- | --- | --- |
| 终端 | foot | **kitty**（字体 Maple Mono NF CN，配置在 [kitty/](/kitty)） | `manifest.toml`、`hypr/variables.lua`、`hypr/hyprland/rules.lua`、`hypr/utils/functions.lua` |
| Shell | fish | **zsh**（配置 [zsh/.zshrc](/zsh/.zshrc)，末尾加载 `~/.config/caelestia/user-config.zsh`） | `manifest.toml`（组件 `zsh`，安装到 `~/.zshrc`） |
| 浏览器 | firefox + zen | **google-chrome**（无主题集成，外观走 GTK 跟随配色） | `manifest.toml`（组件 `chrome`）、`hypr/variables.lua` |
| 编辑器 | vscode/vscodium/zed/nvim | 仅 **zed / nvim / micro**（vscode 全套及 Caelestia 集成扩展已删除） | `manifest.toml`、`hypr/variables.lua`（`editor = "zeditor"`，注意二进制名是 zeditor 不是 zed） |
| 文档 | 英文 | 全部汉化 | 各 `README.md`、`.github/` |

未改动但值得知道的：Hyprland 光标默认 `sweet-cursors`（未安装），实际用 `Bibata-Modern-Ice`——通过用户覆盖文件设置（见下），仓库默认值保持上游以减轻同步压力。

## 仓库外的用户配置（系统最终形态的一半在这里）

魔改遵循一个原则：**能放用户覆盖文件的就不改仓库源码**（上游同步零冲突）。以下文件不在仓库中，但属于配置的组成部分，新环境需手动恢复：

| 文件 | 作用 |
| --- | --- |
| `~/.config/caelestia/hypr-vars.lua` | 变量覆盖：`terminal = "kitty"`、`browser = "google-chrome-stable"`、`cursorTheme = "Bibata-Modern-Ice"` |
| `~/.config/caelestia/hypr-user.lua` | 输入法环境变量（XMODIFIERS/QT_IM_MODULE/QT_IM_MODULES/SDL_IM_MODULE，**故意不含 GTK_IM_MODULE**，GTK 由 settings.ini 低优先级接管）；`hyprland.start` 时启动 `fcitx5 -d` 和 `dex --autostart`（dex 会先等 shell 托盘宿主 StatusNotifierWatcher 就绪，30s 兜底放行） |
| `~/.config/caelestia/shell.json` | 透明度开关；`session.commands.logout = ["~/.config/caelestia/logout.sh"]`（见下） |
| `~/.config/caelestia/cli.json` | sysmon btop 命令（kitty + zsh）；`wallpaper`/`theme` 的 postHook 指向 SDDM 同步脚本 |
| `~/.config/caelestia/logout.sh` | 注销包装器（详见 shell 仓库 README 的"已知问题"） |
| `~/.config/caelestia/user-config.zsh` | zsh 自定义入口（空） |
| `~/.config/environment.d/ime.conf` + `~/.gtkrc-2.0` + `~/.config/gtk-{3,4}.0/settings.ini` | 输入法环境变量与 GTK IM 模块（方案来自 [Shorin 的 Arch 指南](https://github.com/SHORiN-KiWATA/Shorin-ArchLinux-Guide)，注意 environment.d 在 SDDM 直启的会话里不生效，故 Hyprland 侧在 hypr-user.lua 再设一遍非 GTK 变量） |
| `~/.config/autostart/mihomo-party.desktop` | Clash Party 自写（应用内开关维护），由 `dex --autostart` 执行 |

## 维护须知

- **不要直接编辑 `~/.config/hypr/` 下的托管文件**——个人改动一律走 `hypr-vars.lua` / `hypr-user.lua`；确实要改托管默认值的，改仓库后重新安装
- **不要安装 uwsm（重要）**：旧机器是 SDDM 直启 Hyprland；装了 uwsm 后 SDDM 会话列表多出按字母序更靠前的 `hyprland-uwsm.desktop`，全新 SDDM 默认选中它，整个会话被 systemd 接管，`xdg-desktop-autostart.target` 会和 `dex --autostart` 抢同一个 desktop 文件——双实例竞争导致 Clash Party 开机不静默（second-instance 唤醒主窗口）且托盘注册失败。曾以 `systemctl --user mask 'app-mihomo\x2dparty@autostart.service'` 兜底（mask 优先级高于生成单元，应用内重写 desktop 文件也不受影响），现保留作保险；根治是卸载 uwsm，会话回到 SDDM 直启，dex 仍是唯一自启通道
- 组件清单现状（可选组件只启用 zed / nvim，micro 为默认组件；spotify、discord、todoist、uwsm 不使用）：`hypr, zsh, kitty, fastfetch, btop, micro, thunar, starship, chrome, gtk, qt, auth, network, bluetooth, pipewire, clipboard, fonts, tools, zed, nvim`
- **不要运行 `caelestia install` 重装 shell**——它按 manifest 装的是官方 AUR 包 `caelestia-shell`，会顶掉自编译的 `caelestia-shell-imyifeng`（含中文翻译）
- 跟随上游：`git remote add upstream https://github.com/caelestia-dots/caelestia.git` 后 fetch/rebase，重点冲突区是 `manifest.toml` 与 `hypr/`；shell 仓库的翻译/打包维护见其 README

## 默认快捷键（上游默认，可经 hypr-vars.lua 覆盖）

### 启动器与工作区

| 快捷键 | 功能 |
| --- | --- |
| `Super`（按一下） | 启动器（输入 `>` 前缀可用命令，输入 `@` 前缀切特殊工作区） |
| `Super + 1~9, 0` / `Super + Alt + 1~9, 0` | 切换 / 移动窗口到工作区 1~10 |
| `Ctrl + Super + 1~9, 0` | 工作区分组（×10） |
| `Super + 滚轮` / `Super + Page_Up/Down` | 上/下一个工作区 |
| `Super + Alt + S`、`Ctrl + Super + Shift + Up/Down` | 移入 / 移出特殊工作区 |
| `Super + S` / `Super + M` / `Super + D` / `Super + R` / `Ctrl + Shift + Esc` | 特殊工作区：星标 / 音乐 / 通讯 / 待办 / 系统监视器 |

### 窗口

| 快捷键 | 功能 |
| --- | --- |
| `Super + C` | 编辑器（zeditor） |
| `Super + T` / `Super + W` / `Super + E` | 终端（kitty）/ 浏览器（Chrome）/ 文件管理器（thunar） |
| `Super + Q` / `Super + F` / `Super + Alt + F` / `Super + Alt + Space` | 关闭 / 全屏 / 最大化 / 浮动 |
| `Super + 方向键` / `Super + Shift + 方向键` | 聚焦 / 移动窗口 |
| `Super + Comma` / `Super + Shift + Comma` / `Super + U` | 合并分组 / 锁定分组 / 移出分组 |
| `Alt + Tab`（±Shift / ±Ctrl） | 分组内 / 分组间循环 |
| `Ctrl + Super + Backslash` | 窗口居中 |

### 会话与 shell

| 快捷键 | 功能 |
| --- | --- |
| `Ctrl + Alt + Delete` | 会话菜单（注销走 [logout.sh](https://github.com/imyifeng/caelestia-shell#已知问题)，修复了 SDDM 黑屏） |
| `Super + L` / `Super + Shift + L` | 锁屏 / 睡眠 |
| `Ctrl + Super + Alt + R` / `Ctrl + Super + Shift + R` | 重启 / 杀掉 shell |
| `Super + N` / `Super + K` | 侧边栏 / 全部面板 |
| `Ctrl + Alt + C` | 清除通知 |

### 截屏录屏与其他

| 快捷键 | 功能 |
| --- | --- |
| `Print` / `Super + Shift + S` / `Super + Shift + Alt + S` | 截图 / 冻结截图 / 选区截图 |
| `Ctrl + Alt + R` / `Super + Alt + R` / `Super + Shift + Alt + R` | 录屏（无声音 / 带声音 / 选区） |
| `Super + V` / `Super + Alt + V` / `Ctrl + Shift + Alt + V` | 剪贴板历史 / 删除模式 / 粘贴最新 |
| `Super + Period` | 表情选择器 |
| `Super + Shift + C` | 取色器 |
| `Ctrl + Super + Space/Equal/Minus/Backspace` | 播放暂停 / 下一曲 / 上一曲 / 停止 |
| `Super + Shift + M` | 静音 |

## 致谢

上游 [caelestia-dots](https://github.com/caelestia-dots)：[dots](https://github.com/caelestia-dots/caelestia) · [shell](https://github.com/caelestia-dots/shell) · [cli](https://github.com/caelestia-dots/cli)，以及 [Hyprland](https://hypr.land)、[Quickshell](https://quickshell.outfoxxed.me)。
