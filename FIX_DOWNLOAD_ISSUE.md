# 修复下载文件问题

## 问题描述
打包后的Mac应用在点击下载书籍时提示"创建文件失败"，这是因为打包后的应用在沙盒环境中无法在相对路径创建文件。

## 解决方案
已修改 `decrypt/weread.go` 文件，将下载路径从相对路径 `./book/` 改为用户文档目录 `~/Documents/WereadBooks/`。

## 具体修改
1. 添加了 `os/user` 和 `path/filepath` 导入
2. 添加了 `getDownloadPath()` 函数来获取用户文档目录
3. 修改了 `DownloadBook()` 函数使用用户文档目录而不是相对路径

## 重新构建应用
现在需要重新构建应用以应用这些更改：

```bash
# 进入项目目录
cd /Users/qingsimuxueyichangan/Documents/github/weread_downloader

# 构建应用
wails build -config wails-mac.json
```

## 下载文件位置
修复后，下载的书籍将保存在：
```
~/Documents/WereadBooks/[用户ID]/[书名]/
```

其中：
- `~/Documents/WereadBooks/` 是主下载目录
- `[用户ID]` 是微信读书的用户ID
- `[书名]` 是具体书籍的文件夹

## 验证修复
重新构建应用后，您可以：
1. 启动应用
2. 登录微信读书
3. 选择一本书进行下载
4. 检查 `~/Documents/WereadBooks/` 目录下是否生成了对应的书籍文件

这个修复解决了打包应用无法创建文件的问题，现在应用可以在用户文档目录中正常创建和写入文件。