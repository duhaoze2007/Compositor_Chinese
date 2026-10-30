# Compositor 中文版

Compositor 是一款免费开源的 macOS 图像编辑器，用来做合成与后期处理，操作方式贴近 Photoshop。
本仓库是它的**简体中文汉化版**，基于上游 [robbietilton/Compositor](https://github.com/robbietilton/Compositor)（MIT 许可）。

只做汉化：界面文案全部来自 `Compositor/Resources/zh-Hans.lproj/Localizable.strings`，没有改动任何编辑、渲染、文件格式相关的逻辑。

## 下载安装

1. 打开 [Releases](https://github.com/duhaoze2007/Compositor_Chinese/releases)，下载最新的 `Compositor-<版本>-zh.<构建号>.zip`。
2. 解压后把 `Compositor.app` 拖进「应用程序」文件夹，也可以直接双击运行。
3. 首次打开时，如果 macOS 提示「无法验证开发者」，在「系统设置 › 隐私与安全性」里点「仍要打开」。

系统要求：macOS 26 或更新版本（与上游一致）。

## 从源码构建

需要 Xcode 26.6 或更新版本：

```sh
xcodebuild -project Compositor.xcodeproj -scheme Compositor -configuration Release build
```

构建出的 `Compositor.app` 里已经包含中文文案，不需要额外安装语言包。仓库里的
[构建中文版](.github/workflows/release-app.yml) 工作流会在每次推送 `main` 时自动构建，并把压缩包挂到
`zh-latest` 这个预发布标签下。

## 汉化说明

* 译文以英文界面原文为键，放在 `zh-Hans.lproj/Localizable.strings`，形如：

  ```strings
  "New Canvas…" = "新建画布…";
  "Gaussian Blur" = "高斯模糊";
  "Enter a whole number from 1 to %lld px." = "请输入 1 到 %lld 像素之间的整数。";
  ```

* 术语按 Adobe Photoshop 简体中文版的叫法：图层、蒙版、选区、剪贴蒙版、调整图层、色阶、曲线、色相/饱和度、正片叠底、滤色……
* 查不到的键会原样显示英文，所以漏翻不会出现空白或乱码。
* 更细的规则和后续维护方式见 [LOCALIZATION.md](LOCALIZATION.md)。

## 与上游的差异

| 文件 | 改动 |
| --- | --- |
| `Compositor/Resources/zh-Hans.lproj/` | 新增：中文文案（`Localizable.strings`、`InfoPlist.strings`） |
| `Compositor/UI/LocalizedText.swift` | 新增：`zh()` 帮助函数，把模型层传上来的 `String` 接入本地化 |
| `Config/Info.plist` | 声明中文为开发语言与唯一本地化，关闭自动更新检查 |
| `Compositor/UI/*.swift`、`CompositorApp.swift` | 只把动态文案包进 `zh(…)`，不改逻辑 |
| `.github/workflows/release-app.yml` | 新增：自动构建并发布中文版 |
| `README.md`、`LOCALIZATION.md`、`RELEASE_NOTES.md` | 新增/改写：中文说明 |

没有改动：渲染管线、C 像素代码、PSD/GIF/RAW 读写、项目文件格式、快捷键绑定、测试。

英文说明见 [README.en.md](README.en.md)。

## 许可

沿用上游 MIT 许可，见 [LICENSE](LICENSE)。原项目版权归 Robbie Tilton 所有。
