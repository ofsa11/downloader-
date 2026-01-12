#!/bin/bash

# 微信读书下载器 Mac打包脚本
# 请在确保已安装Go和Wails后运行此脚本

set -e  # 遇到错误时停止执行

echo "微信读书下载器 Mac应用打包脚本"
echo "================================"

echo "检查Go是否已安装..."
if ! command -v go &> /dev/null; then
    echo "错误: 未找到Go。请先安装Go 1.18或更高版本。"
    echo "可以从 https://golang.org/dl/ 下载安装"
    exit 1
fi

echo "Go版本: $(go version 2>/dev/null || echo "无法获取版本")"

echo "检查Wails是否已安装..."
if ! command -v wails &> /dev/null; then
    echo "Wails未安装，正在安装Wails CLI..."
    go install github.com/wailsapp/wails/v2/cmd/wails@latest
    echo "Wails安装完成"
    # 添加Wails到PATH
    export PATH=$PATH:$(go env GOPATH)/bin
fi

echo "Wails版本: $(wails version 2>/dev/null || echo "无法获取版本")"

# 返回项目根目录
cd "$(dirname "$0")"

echo "安装Go依赖..."
GOOS=darwin go mod tidy

echo "安装前端依赖..."
cd frontend
npm install

echo "返回项目根目录..."
cd ..

echo "开始构建Mac应用..."
# 直接构建，Wails会自动读取配置
wails build

echo "================================"
echo "构建完成！"
echo "Mac应用已生成在 build/bin/ 目录下"
echo "文件名为 weread_downloader.app"
echo "================================"

# 打开生成目录
open build/bin/ 2>/dev/null || echo "请手动查看 build/bin/ 目录获取应用"