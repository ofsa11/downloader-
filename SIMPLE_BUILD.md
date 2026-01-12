# 简化构建指南

由于当前环境限制，以下是在您本地终端中手动执行的简化构建步骤：

## 第一步：安装Wails（如果尚未安装）
```bash
go install github.com/wailsapp/wails/v2/cmd/wails@latest
```

## 第二步：验证安装
```bash
go version
node --version
wails version
```

## 第三步：构建项目
```bash
# 进入项目目录
cd /Users/qingsimuxueyichangan/Documents/github/weread_downloader

# 安装Go依赖
go mod tidy

# 进入前端目录并安装依赖
cd frontend
npm install

# 返回项目根目录
cd ..

# 构建Mac应用
wails build -config wails-mac.json
```

## 替代构建命令（如果上述命令失败）
```bash
# 使用默认配置构建
wails build

# 或为macOS特定构建
GOOS=darwin wails build
```

## 检查构建结果
构建成功后，应用将位于：
```
/Users/qingsimuxueyichangan/Documents/github/weread_downloader/build/bin/weread_downloader.app
```

## 运行应用
```bash
open /Users/qingsimuxueyichangan/Documents/github/weread_downloader/build/bin/weread_downloader.app
```

## 常见问题解决

如果遇到权限问题：
```bash
xcode-select --install
```

如果wails命令未找到，请确保GOPATH已添加到PATH：
```bash
export PATH=$PATH:$(go env GOPATH)/bin
```

按照这些步骤，您应该能够成功构建微信读书下载器的Mac应用。