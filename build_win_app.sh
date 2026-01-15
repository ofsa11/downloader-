#!/bin/bash

# 微信读书下载器 Windows打包脚本 (在macOS上交叉编译)
# 请在确保已安装Go和Wails后运行此脚本

set -e  # 遇到错误时停止执行

echo "下载器 Windows打包脚本"
echo "================================"

echo "检查Go是否已安装..."
if ! command -v go &> /dev/null; then
    echo "错误: 未找到Go。请先安装Go 1.18或更高版本。"
    exit 1
fi

echo "Go版本: $(go version 2>/dev/null || echo "无法获取版本")"

echo "检查Wails是否已安装..."
if ! command -v wails &> /dev/null; then
    echo "Wails未安装，正在安装Wails CLI..."
    go install github.com/wailsapp/wails/v2/cmd/wails@latest
    export PATH=$PATH:$(go env GOPATH)/bin
fi

echo "Wails版本: $(wails version 2>/dev/null || echo "无法获取版本")"

# 返回项目根目录
cd "$(dirname "$0")"

echo "安装Go依赖..."
go mod tidy

echo "安装前端依赖..."
cd frontend
npm install

echo "返回项目根目录..."
cd ..

echo "清理旧的构建文件..."
rm -rf build/bin/weread_downloader.exe
rm -rf build/bin/downloader.exe
rm -rf build/bin/下载器.exe

echo "开始构建Windows应用..."
# 使用 -platform windows/amd64 进行交叉编译
# -skipbindings 跳过绑定生成（如果不需要）
# -s -w 减小体积
wails build -platform windows/amd64

echo "================================"
echo "构建完成！"
echo "Windows应用已生成在 build/bin/ 目录下"
echo "================================"

# 打开生成目录
open build/bin/ 2>/dev/null || echo "请手动查看 build/bin/ 目录获取应用"
