#!/bin/bash
# 代理 API 服务安装脚本
# 功能：安装 nodejs、下载并配置代理 API 服务

set -e

echo "========== 开始安装代理 API 服务 =========="

# 1. 安装 Node.js 24
echo "[1/8] 检查并安装 Node.js 24..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" = "24" ]; then
        echo "Node.js 24 已安装，跳过安装步骤"
    else
        echo "Node.js 版本不是 24，正在安装..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
        . "$HOME/.nvm/nvm.sh"
        nvm install 24
    fi
else
    echo "Node.js 未安装，正在安装..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
    . "$HOME/.nvm/nvm.sh"
    nvm install 24
fi

# 2. 准备目录并下载 API 代理服务脚本
echo "[2/8] 下载 API 代理服务脚本..."
PROXY2API_DIR="$HOME/proxy2api"
if [ -d "$PROXY2API_DIR" ]; then
    echo "proxy2api 目录已存在，删除旧目录..."
    rm -rf "$PROXY2API_DIR"
fi
mkdir -p "$PROXY2API_DIR"
wget https://github.com/pingmike2/freebuff2api-wokers/archive/refs/heads/main.zip -O /tmp/proxy2api.zip

# 3. 解压文件
echo "[3/8] 解压文件到 proxy2api 目录..."
unzip -q /tmp/proxy2api.zip -d /tmp/proxy2api-tmp
rm -rf "$PROXY2API_DIR"
mv /tmp/proxy2api-tmp/freebuff2api-wokers-main "$PROXY2API_DIR"
rm -rf /tmp/proxy2api-tmp /tmp/proxy2api.zip

# 4. 创建 credentials 目录
echo "[4/8] 创建 credentials 目录..."
mkdir -p "$PROXY2API_DIR/credentials"

# 5. 获取用户输入
echo "[5/8] 请输入 API 代理凭据..."
read -p "请输入 API Token: " API_TOKEN
read -p "请输入 API Email: " API_EMAIL

# 6. 写入凭据文件
echo "[6/8] 写入凭据文件..."
cat > "$PROXY2API_DIR/credentials/freebuff_credentials.json" << EOF
{
  "accounts": {
    "001": {
      "id": "001",
      "email": "$API_EMAIL",
      "authToken": "$API_TOKEN",
      "credits": 0
    }
  }
}
EOF

# 7. 安装依赖
echo "[7/8] 安装项目依赖..."
cd "$PROXY2API_DIR"
npm i

# 8. 创建 systemd 服务
echo "[8/8] 创建并启动 systemd 服务..."
cat > /etc/systemd/system/proxy2api.service << EOF
[Unit]
Description=Proxy2API Service
After=network.target

[Service]
Type=simple
User=$(whoami)
WorkingDirectory=$PROXY2API_DIR
ExecStart=$(which node) $PROXY2API_DIR/server.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 重新加载 systemd 并启动服务
systemctl daemon-reload
systemctl start proxy2api
systemctl enable proxy2api

# 9. 配置防火墙
echo "配置防火墙，开放 8787 端口..."
ufw allow 8787/tcp

echo "========== 代理 API 服务安装完成 =========="
echo "服务状态: systemctl status proxy2api"
echo "访问地址: http://服务器IP:8787"
