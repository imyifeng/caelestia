-- 用户自定义 Hyprland 配置（在 hyprland.lua 末尾加载，可用 hl.* API）

-- 输入法环境变量（方案来自 Shorin 的 Arch 指南）
-- 故意不含 GTK_IM_MODULE：GTK 由 settings.ini 低优先级接管
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULES", "wayland;fcitx")
hl.env("SDL_IM_MODULE", "fcitx")

hl.on("hyprland.start", function()
    hl.exec_cmd("fcitx5 -d")
    -- 等 shell 托盘宿主（StatusNotifierWatcher）就绪再执行 XDG 自启，
    -- 否则 Electron 应用（如 Clash Party）开机抢跑会注册托盘失败；30 秒兜底放行
    hl.exec_cmd(
        "timeout 30 sh -c 'until busctl --user get-property org.kde.StatusNotifierWatcher /StatusNotifierWatcher org.kde.StatusNotifierWatcher RegisteredStatusNotifierItems >/dev/null 2>&1; do sleep 0.3; done; exec dex --autostart'"
    )
end)
