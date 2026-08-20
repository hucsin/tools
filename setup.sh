#!/bin/bash
# 环境构建主脚本
# 功能：提供菜单选择执行各个子脚本

set -e

# 统一路径变量
HOME_DIR="$HOME"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 子脚本路径
VPN_SETUP="$SCRIPT_DIR/vpn/setup_vpn.sh"
CHROME_SETUP="$SCRIPT_DIR/chrome/setup_chrome.sh"
PROXY2API_SETUP="$SCRIPT_DIR/proxy2api/setup_proxy2api.sh"

# 打印菜单
print_menu() {
    echo "=========================================="
    echo "       环境构建脚本 v1.0"
    echo "=========================================="
    echo ""
    echo "请选择要执行的操作（多个选项用空格分隔）："
    echo ""
    echo "  1) 安装 VPN 服务 (v2ray)"
    echo "  2) 安装 Chrome 浏览器服务"
    echo "  3) 安装代理 API 服务 (proxy2api)"
    echo "  4) 安装全部服务"
    echo "  0) 退出"
    echo ""
    echo "=========================================="
}

# 安装 VPN 服务
install_vpn() {
    echo ""
    echo ">>> 开始安装 VPN 服务..."
    bash "$VPN_SETUP"
    echo ">>> VPN 服务安装完成"
}

# 安装 Chrome 服务
install_chrome() {
    echo ""
    echo ">>> 开始安装 Chrome 浏览器服务..."
    bash "$CHROME_SETUP"
    echo ">>> Chrome 浏览器服务安装完成"
}

# 安装代理 API 服务
install_proxy2api() {
    echo ""
    echo ">>> 开始安装代理 API 服务..."
    bash "$PROXY2API_SETUP"
    echo ">>> 代理 API 服务安装完成"
}

# 主循环
while true; do
    print_menu
    read -p "请输入选项: " choices
    
    # 如果用户输入为空，继续
    if [ -z "$choices" ]; then
        continue
    fi
    
    # 处理输入
    for choice in $choices; do
        case $choice in
            1)
                install_vpn
                ;;
            2)
                install_chrome
                ;;
            3)
                install_proxy2api
                ;;
            4)
                install_vpn
                install_chrome
                install_proxy2api
                ;;
            0)
                echo "退出脚本"
                exit 0
                ;;
            *)
                echo "无效选项: $choice"
                ;;
        esac
    done
    
    echo ""
    echo "=========================================="
    read -p "按回车键返回菜单..."
done
