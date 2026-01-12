# 微信读书下载器 Mac打包指南

本指南将帮助您将微信读书下载器项目打包成Mac可运行程序。

## 系统要求

- macOS 10.15 或更高版本
- Xcode命令行工具

## 安装必要工具

### 1. 安装Go语言

从 [https://golang.org/dl/](https://golang.org/dl/) 下载并安装Go 1.18或更高版本。

安装后验证：
```bash
go version
```

### 2. 安装Node.js

推荐使用 [Node.js官网](https://nodejs.org/) 或通过Homebrew安装：

```bash
brew install node
```

### 3. 安装Wails CLI

```bash
go install github.com/wailsapp/wails/v2/cmd/wails@latest
```

## 项目依赖安装

### 1. 安装Go依赖

```bash
cd /Users/qingsimuxueyichangan/Documents/github/weread_downloader
go mod tidy
```

### 2. 安装前端依赖

```bash
cd /Users/qingsimuxueyichangan/Documents/github/weread_downloader/frontend
npm install
```

## 构建Mac应用

### 方法一：使用打包脚本

运行项目根目录下的打包脚本：

```bash
cd /Users/qingsimuxueyichangan/Documents/github/weread_downloader
chmod +x build_mac_app.sh
./build_mac_app.sh
```

### 方法二：手动构建

```bash
cd /Users/qingsimuxueyichangan/Documents/github/weread_downloader
wails build
```

## 构建选项

### 为不同架构构建
- 为Intel Mac构建: `wails build -platform darwin/amd64`
- 为Apple Silicon Mac构建: `wails build -platform darwin/arm64`
- 通用二进制（支持两种架构）: `wails build -platform darwin/universal`

### 开发模式构建
```bash
wails dev
```

## 输出结果

构建完成后，Mac应用将位于 `build/bin/` 目录下，文件名为 `weread_downloader.app`。

## 注意事项

1. **代码签名**：如果要分发给其他用户，需要对应用进行代码签名。
2. **安全设置**：首次运行时，macOS可能会提示"无法验证开发者"，需要在"安全性和隐私"设置中允许应用运行。
3. **权限**：应用可能需要网络访问权限来连接微信读书服务器。

## 故障排除

### 如果遇到权限问题
```bash
xcode-select --install
```

### 如果npm安装失败
尝试使用pnpm或yarn：
```bash
# 安装pnpm
npm install -g pnpm

# 使用pnpm安装依赖
cd frontend
pnpm install
```

### 如果构建失败
1. 确保所有依赖都已正确安装
2. 检查Go和Node.js版本是否符合要求
3. 确保有足够的磁盘空间

## 应用结构

打包后的应用结构如下：
```
weread_downloader.app/
├── Contents/
    ├── MacOS/weread_downloader     # 可执行文件
    ├── Resources/                  # 资源文件
    └── Info.plist                  # 应用信息
```

现在您可以将生成的.app文件分发给其他Mac用户使用了。