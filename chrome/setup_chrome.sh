#!/bin/bash
# Chrome 浏览器服务安装脚本
# 功能：通过 Docker 部署 Chrome 浏览器服务

set -e

echo "========== 开始安装 Chrome 浏览器服务 =========="

# 1. 检查并安装 Docker
echo "[1/4] 检查 Docker 是否已安装..."
if ! command -v docker &> /dev/null; then
    echo "Docker 未安装，正在安装 Docker..."
    curl -fsSL https://get.docker.com | sh
    echo "Docker 安装完成"
else
    echo "Docker 已安装，跳过安装步骤"
fi

# 2. 创建配置文件夹
echo "[2/4] 创建配置文件夹 /opt/chrome/config..."
mkdir -p /opt/chrome/config

# 3. 获取当前服务器时区
echo "[3/4] 获取服务器时区..."
TZ=$(cat /etc/timezone 2>/dev/null || echo "Asia/Shanghai")
echo "服务器时区: $TZ"

# 4. 启动 Chrome 容器
echo "[4/4] 启动 Chrome 容器..."
docker run -d \
  --name=chrome \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=$TZ \
  -e LC_ALL=en_GB.UTF-8 \
  -e CUSTOM_USER=admin \
  -e PASSWORD=WJ@chrome.com516 \
  -p 3001:3001 \
  -v /opt/chrome/config:/config \
  --shm-size=1gb \
  --restart unless-stopped \
  linuxserver/chrome:latest

# 5. 配置防火墙
echo "配置防火墙，开放 3001 端口..."
ufw allow 3001/tcp

echo "========== Chrome 浏览器服务安装完成 =========="
echo "访问地址: https://服务器IP:3001"
echo "用户名: admin"
echo "密码: WJ@chrome.com516"
