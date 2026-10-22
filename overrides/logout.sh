#!/usr/bin/env bash
# 注销包装器：修复 SDDM 注销黑屏（详见 caelestia-shell 仓库 README「已知问题」）
# hyprshutdown 优雅退出 → 超时 8 秒改走 hyprctl dispatch exit → 仍存活则强杀整个用户会话
if command -v hyprshutdown >/dev/null 2>&1; then
    hyprshutdown &
    pid=$!
    for _ in $(seq 1 80); do
        kill -0 "$pid" 2>/dev/null || exit 0
        sleep 0.1
    done
    kill "$pid" 2>/dev/null
fi
hyprctl dispatch exit
sleep 5
pgrep -x Hyprland >/dev/null 2>&1 && pkill -KILL -u "$USER"
