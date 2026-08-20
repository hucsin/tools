#!/bin/bash
# 一键下载并执行远程工具脚本
# 功能：从 GitHub 下载 tools 仓库并执行其中的 setup.sh

set -e

# 统一路径变量
HOME_DIR="$HOME"
REPO_URL="https://github.com/hucsin/tools/archive/refs/heads/main.zip"
WORK_DIR="/tmp/freebuff-tools-$$"
ZIP_FILE="$WORK_DIR/tools.zip"
EXTRACT_DIR="$WORK_DIR/tools-main"

# 确保退出时清理临时目录
cleanup() {
    rm -rf "$WORK_DIR"
}
trap cleanup EXIT

mkdir -p "$WORK_DIR"

echo "========== 开始下载并执行远程工具脚本 =========="

# 1. 下载 zip 文件
echo "[1/3] 正在下载工具包..."
wget -q "$REPO_URL" -O "$ZIP_FILE"

# 2. 解压文件
echo "[2/3] 正在解压文件..."
unzip -q "$ZIP_FILE" -d "$WORK_DIR"

# 3. 进入目录并执行 setup.sh
echo "[3/3] 正在执行 setup.sh..."
cd "$EXTRACT_DIR"
bash setup.sh

echo "========== 远程工具脚本执行完成 =========="
