#!/bin/bash
# VPN 服务安装脚本
# 功能：安装 v2ray VPN 服务并配置防火墙

set -e

echo "========== 开始安装 VPN 服务 =========="

# 1. 执行 v2ray 安装脚本
echo "[1/3] 正在下载并执行 v2ray 安装脚本..."
bash <(wget -qO- -o- https://github.com/233boy/v2ray/raw/master/install.sh)

# 2. 配置防火墙
echo "[2/3] 正在配置防火墙，开放 8788 端口..."
ufw allow 8788/tcp

# 3. 从第一个配置文件中提取端口并开放防火墙
echo "[3/3] 正在从配置文件中提取端口并开放防火墙..."

CONF_DIR="/etc/v2ray/conf"
CONF_FILE=$(ls "$CONF_DIR"/*.json 2>/dev/null | head -n 1)

if [ -z "$CONF_FILE" ]; then
    echo "警告：未在 $CONF_DIR 中找到配置文件，跳过防火墙配置"
else
    PORT=$(grep -oE '"port"[^0-9]*[0-9]+' "$CONF_FILE" | grep -oE '[0-9]+$' | head -n 1)
    if [ -n "$PORT" ]; then
        ufw allow "$PORT"/tcp
        echo "已开放端口 $PORT/tcp（配置文件：$CONF_FILE）"
    else
        echo "警告：无法从 $CONF_FILE 中提取端口，跳过防火墙配置"
    fi
fi

echo "========== VPN 服务安装完成 =========="
echo "请查看上面的输出获取连接信息"
