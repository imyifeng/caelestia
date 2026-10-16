> [!NOTE]
> 本仓库为**个人自用修改版**，在上游 [caelestia-dots/caelestia](https://github.com/caelestia-dots/caelestia) 的基础上进行了个人定制，文档均已汉化。
> 因此与上游可能存在差异，通用功能与更新请以上游仓库为准。

# caelestia

这是 Caelestia dotfiles 的主仓库，包含各种应用的用户配置。

> [!IMPORTANT]
> 本仓库旧版的 `install.fish` 安装脚本已被移除，改用 [CLI][cli-repo] 的 install 命令。
>
> 如果你仍在使用旧脚本的既有安装，请先更新 CLI，然后运行 install 命令完成迁移。

> [!IMPORTANT]
> 我们已改用 Lua 编写 Hyprland 配置！
> 如果你有自定义的 `~/.config/caelestia/hypr-user.conf` 或 `~/.config/caelestia/hypr-vars.conf`，
> 请将其转换为 Lua，可以手动转换，也可以使用网上的转换工具。
>
> 有关这些文件用法的更多信息，请参阅[配置](#配置)一节。

## 安装（Arch Linux）

从 AUR 安装 CLI，然后运行 `caelestia install`。

例如：

```sh
paru -S caelestia-cli
caelestia install
```

### 手动安装

克隆本仓库，然后浏览[清单文件](/manifest.toml)，安装你想启用的组件所需的全部软件包，并复制这些组件的所有条目。

以 hyprland 组件为例：

```sh
git clone https://github.com/caelestia-dots/caelestia.git
cd caelestia
sudo pacman -S --needed hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk ttf-jetbrains-mono-nerd
mkdir -p $XDG_CONFIG_HOME/hypr
cp -r hypr/. $XDG_CONFIG_HOME/hypr/
```

## 更新

使用 `caelestia update` 执行完整的系统更新并更新 dots。

## 用法

> [!NOTE]
> 这些 dots 不包含登录管理器（目前），因此除非你想从 TTY 登录，否则必须自行安装登录管理器。
> 我推荐 [`greetd`](https://sr.ht/~kennylevinsen/greetd) 搭配
> [`tuigreet`](https://github.com/apognu/tuigreet)；不过你可以使用任何喜欢的登录管理器。

## 配置

> [!CAUTION]
> 永远不要修改 `~/.config/hypr/` 内的任何文件，否则更新 dots 时会产生冲突。
>
> 任何个人修改都应写入 `~/.config/caelestia/hypr-user.lua` 或 `hypr-vars.lua`，
> 因为安装/更新流程从不修改这些文件。把自己的改动写进 `~/.config/hypr/` 里的文件
> 会导致后续更新无法应用，之后每次更新都得手动解决冲突。

### hypr-vars.lua

大部分 Hyprland 默认值都可以通过在 `~/.config/caelestia/hypr-vars.lua` 中覆盖变量来修改。
你可以用这个文件设置默认应用、快捷键、鼠标光标、窗口装饰等等。
所有可用变量及其默认值请参考 [`variables.lua`](hypr/variables.lua) 文件。

`hypr-vars.lua` 用法示例：

```lua
return {
  -- 修改默认应用：
  browser          = "chromium",       -- 将默认浏览器改为 Chromium

  -- 修改窗口/装饰属性：
  blurEnabled      = false,            -- 禁用窗口模糊
  windowBorderSize = 3,                -- 增大窗口边框尺寸（默认：1）

  -- 修改快捷键：
  kbTerminal       = "SUPER + Return", -- 修改打开终端的快捷键
}
```

### hypr-user.lua

任何自定义 Hyprland 配置都可以放在 `~/.config/caelestia/hypr-user.lua` 中。
该文件在 Hyprland 加载序列的最后加载，因此你可以定制 Hyprland 在预设配置之外的行为，
包括显示器布局、额外的快捷键和窗口规则等。dotfiles 已管理的选项（如快捷键、窗口边框等）
建议优先使用 `hypr-vars.lua` 修改。对于 dots 未覆盖、或需要在变量之外管理的配置，
则应写入 `hypr-user.lua`。
更多 Hyprland 配置方法请阅读其 [wiki](https://wiki.hypr.land/Configuring/Start/)。

### 其他配置

Caelestia 是一个由多部分组成的生态系统，包括 dotfiles（本仓库）、[shell][shell-repo] 和 [CLI][cli-repo]。
Shell 的配置由 `~/.config/caelestia/shell.json` 管理，用于调整 shell 的行为。
CLI 的配置文件（`~/.config/caelestia/cli.json`）可用来调整 CLI 的主题和特殊工作区的处理方式。
有关 shell 和 CLI 的配置详情，请参阅它们各自的仓库。

## 默认快捷键

> [!TIP]
> 所有快捷键都可以通过在 `hypr-vars.lua` 中覆盖对应变量来自定义（shell 重启/终止键除外）。
> 详见[配置](#配置)一节。

### 启动器

| 快捷键                 | 功能       |
| ---------------------- | ---------- |
| `Super`（按下并松开） | 打开启动器 |

---

### 工作区

| 快捷键                                                                                | 功能                              |
| -------------------------------------------------------------------------------------- | --------------------------------- |
| `Super + 1~9, 0`                                                                       | 前往工作区 1~10                   |
| `Super + Alt + 1~9, 0`                                                                 | 将窗口移至工作区 1~10             |
| `Ctrl + Super + 1~9, 0`                                                                | 前往工作区分组（×10）             |
| `Ctrl + Super + Alt + 1~9, 0`                                                          | 将窗口移至工作区分组              |
| `Super + Alt + S`、`Ctrl + Super + Shift + Up`                                         | 将窗口移至特殊工作区              |
| `Ctrl + Super + Shift + Down`                                                          | 将窗口移出特殊工作区              |
| `Super + Alt + 滚轮下`、`Super + Alt + Page_Down`、`Ctrl + Super + Shift + Right`      | 将窗口移至下一个工作区            |
| `Super + Alt + 滚轮上`、`Super + Alt + Page_Up`、`Ctrl + Super + Shift + Left`          | 将窗口移至上一个工作区            |
| `Super + 滚轮下`、`Ctrl + Super + Right`、`Super + Page_Down`                           | 前往下一个工作区                  |
| `Super + 滚轮上`、`Ctrl + Super + Left`、`Super + Page_Up`                              | 前往上一个工作区                  |
| `Ctrl + Super + 滚轮下`                                                                | 前往下一个工作区分组              |
| `Ctrl + Super + 滚轮上`                                                                | 前往上一个工作区分组              |

---

### 窗口分组

| 快捷键                     | 功能                       |
| -------------------------- | -------------------------- |
| `Alt + Tab`                | 切换到分组内下一个窗口     |
| `Shift + Alt + Tab`        | 切换到分组内上一个窗口     |
| `Ctrl + Alt + Tab`         | 切换到下一个分组           |
| `Ctrl + Shift + Alt + Tab` | 切换到上一个分组           |
| `Super + U`                | 将窗口移出分组             |
| `Super + Comma`            | 合并/取消分组              |
| `Super + Shift + Comma`    | 锁定当前分组               |

---

### 窗口操作

| 快捷键                                       | 功能                                          |
| -------------------------------------------- | --------------------------------------------- |
| `Super + Minus`、`Super + Alt + Left`        | 将窗口向左移动分屏                            |
| `Super + Equal`、`Super + Alt + Right`       | 将窗口向右移动分屏                            |
| `Super + Shift + Minus`、`Super + Alt + Up`  | 将窗口向上移动分屏                            |
| `Super + Shift + Equal`、`Super + Alt + Down`| 将窗口向下移动分屏                            |
| `Super + Left/Right/Up/Down`                 | 按方向聚焦窗口                                |
| `Super + Shift + Left/Right/Up/Down`         | 按方向移动窗口                                |
| `Super + LMB`、`Super + Z + LMB`             | 移动窗口（拖拽）                              |
| `Super + RMB`、`Super + X + LMB`             | 调整窗口大小（拖拽）                          |
| `Ctrl + Super + Backslash`                   | 窗口居中                                      |
| `Ctrl + Super + Alt + Backslash`             | 将窗口调整为屏幕的 55×70% 并居中              |
| `Super + Alt + Backslash`                    | 为窗口启用画中画模式                          |
| `Super + P`                                  | 切换窗口固定模式                              |
| `Super + F`                                  | 切换窗口全屏模式                              |
| `Super + Alt + F`                            | 切换窗口最大化模式                            |
| `Super + Alt + Space`                        | 切换窗口浮动模式                              |
| `Super + Q`                                  | 关闭窗口                                      |

---

### 特殊工作区开关

| 快捷键                  | 功能                      |
| ----------------------- | ------------------------- |
| `Super + S`             | 切换特殊工作区            |
| `Ctrl + Shift + Escape` | 切换系统监视器工作区      |
| `Super + M`             | 切换音乐工作区            |
| `Super + D`             | 切换通讯工作区            |
| `Super + R`             | 切换待办工作区            |

---

### 应用

| 快捷键           | 功能                            |
| ---------------- | ------------------------------- |
| `Super + T`      | 终端（默认：kitty）              |
| `Super + W`      | 浏览器（默认：google-chrome-stable） |
| `Super + C`      | 编辑器（默认：zed）             |
| `Super + E`      | 文件管理器（默认：thunar）      |
| `Ctrl + Alt + V` | 音频设置（默认：pwvucontrol）   |

---

### 实用工具

| 快捷键                    | 功能                |
| ------------------------- | ------------------- |
| `Print`                   | 截图                |
| `Super + Shift + S`       | 截图（冻结画面）    |
| `Super + Shift + Alt + S` | 截图（选区）        |
| `Ctrl + Alt + R`          | 录制全屏            |
| `Super + Alt + R`         | 录屏（带声音）      |
| `Super + Shift + Alt + R` | 录制选区            |
| `Super + Shift + C`       | 取色器              |

---

### 媒体

| 快捷键                     | 功能       |
| -------------------------- | ---------- |
| `Ctrl + Super + Space`     | 播放/暂停  |
| `Ctrl + Super + Equal`     | 下一曲     |
| `Ctrl + Super + Minus`     | 上一曲     |
| `Ctrl + Super + Backspace` | 停止播放   |
| `Super + Shift + M`        | 静音       |

---

### 其他

| 快捷键                | 功能                  |
| --------------------- | --------------------- |
| `Ctrl + Alt + Delete` | 打开 shell 会话菜单   |
| `Super + N`           | 切换 shell 侧边栏     |
| `Ctrl + Alt + C`      | 清除 shell 通知       |
| `Super + K`           | 显示所有 shell 面板   |
| `Super + L`           | 锁定屏幕              |
| `Super + Alt + L`     | 恢复 shell 锁屏       |
| `Super + Shift + L`   | 执行睡眠命令          |

---

### 剪贴板 / 表情

| 快捷键                   | 功能                             |
| ------------------------ | -------------------------------- |
| `Super + V`              | 打开剪贴板历史                   |
| `Super + Alt + V`        | 打开剪贴板历史（删除模式）       |
| `Ctrl + Shift + Alt + V` | 粘贴最近的剪贴板条目             |
| `Super + Period`         | 打开表情选择器                   |

---

### Shell

| 快捷键                     | 功能       |
| -------------------------- | ---------- |
| `Ctrl + Super + Alt + R`   | 重启 shell |
| `Ctrl + Super + Shift + R` | 终止 shell |

[shell-repo]: https://github.com/caelestia-dots/shell
[cli-repo]: https://github.com/caelestia-dots/cli
