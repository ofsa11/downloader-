# 快速构建指南

在您完成必要工具安装后，可以使用以下命令快速构建Mac应用：

## 前提条件
确保您已完成以下安装：
1. Go 1.18+ 
2. Node.js
3. Wails CLI

## 构建命令

### 1. 使用默认配置构建
```bash
cd /Users/qingsimuxueyichangan/Documents/github/weread_downloader
wails build
```

### 2. 使用macOS特定配置构建
```bash
cd /Users/qingsimuxueyichangan/Documents/github/weread_downloader
wails build -config wails-mac.json
```

### 3. 为不同架构构建
- Intel Mac: `wails build -platform darwin/amd64 -config wails-mac.json`
- Apple Silicon Mac: `wails build -platform darwin/arm64 -config wails-mac.json`
- 通用二进制: `wails build -platform darwin/universal -config wails-mac.json`

## 输出位置
构建完成后的应用位于：
`/Users/qingsimuxueyichangan/Documents/github/weread_downloader/build/bin/weread_downloader.app`

## 验证构建
构建完成后，您可以直接运行应用进行测试：
```bash
open /Users/qingsimuxueyichangan/Documents/github/weread_downloader/build/bin/weread_downloader.app
```

## 构建脚本
您也可以使用项目根目录下的构建脚本：
```bash
chmod +x build_mac_app.sh
./build_mac_app.sh
```