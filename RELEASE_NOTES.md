# Compositor 中文版 1.5.12（构建 58）

发布日期：2026-10-30
上游版本：[Compositor 1.5.12](https://github.com/robbietilton/Compositor/tree/fc3c81a)（commit `fc3c81a`）

---

## 这一版做了什么

把 Compositor 的整套界面翻译成了简体中文，共 **1580 条文案**，覆盖菜单栏、工具、面板、对话框、
提示与错误信息。除文案外没有改动任何功能。

### 汉化范围

* **菜单栏**：文件、编辑、图像、图层、选择、滤镜、视图、窗口、帮助，以及快捷菜单里的动态项
  （向下合并 / 合并图层 / 合并组、显示/隐藏图层、创建/释放剪贴蒙版、上次滤镜、对齐与分布等）。
* **工具箱**：移动、选框、套索、魔棒/对象选择、裁切、画笔、污点修复、仿制图章、涂抹、渐变、
  形状、文字、吸管、抓手、缩放 —— 名称与悬浮提示都是中文。
* **面板**：图层面板、属性栏、导航器、颜色面板、GIF 时间轴、命令面板（⌘F 搜索命令）等。
* **对话框**：新建画布、画布大小、图像大小、导出为（PNG/JPEG/GIF/通道打包）、裁切、变换、
  网格设置、键盘快捷键一览、颜色范围、色相/饱和度、色阶、曲线、Camera Raw、滤镜面板、
  PSD 转换提示、导入与保存的各类确认框。
* **提示与报错**：画布操作提示、图层/蒙版操作说明、导入超限、格式版本不符、导出失败等。
* **数字文案**：画布与图像尺寸、缩放百分比、GIF 帧数与时延、导出进度，保留 `%lld` / `%@` 占位符。
* **应用名**：菜单栏与「关于」显示为「Compositor 中文版」。

### 术语

按 Adobe Photoshop 简体中文版的译法统一，例如：图层 / 蒙版 / 选区 / 剪贴蒙版 / 调整图层 /
混合模式（正片叠底、滤色、叠加、柔光……）/ 色阶 / 曲线 / 色相饱和度 / 黑白 / 色彩平衡 /
高斯模糊 / 动感模糊 / 晕影 / 泛光 / 边缘光 / 镜头校正 / 向下合并 / 羽化 / 容差。

Camera Raw、Photoshop、PSD、PSB、PNG、JPEG、GIF、CMYK、RGB、sRGB、HDR、EXR、GPU 等专有名词保持原样。

### 已知情况

* 用户数据不翻译：文件名、图层名、项目名、字体名、ICC 配置文件、最近打开列表里的项目名。
* 少量由运行时拼接、且拼接结果无法预先列出的提示仍是英文（例如画布底部的修饰键提示句），
  这类文案留英文比出现「半句中文」更稳。
* Camera Raw 面板的专业参数名保留 Photoshop 的常用写法，便于与教程对照。
* 中文版关闭了自动更新检查：上游更新会用英文版覆盖中文文案。需要时可在菜单里手动「检查更新…」。

---

## 安装

**方式一：下载压缩包**

1. 下载本页附件 `Compositor-1.5.12-zh.58.zip`。
2. 解压得到 `Compositor.app`，拖进「应用程序」文件夹。
3. 首次打开若提示「无法验证开发者」，到「系统设置 › 隐私与安全性」点「仍要打开」。

**方式二：从源码构建**

```sh
git clone https://github.com/duhaoze2007/Compositor_Chinese.git
cd Compositor_Chinese
xcodebuild -project Compositor.xcodeproj -scheme Compositor -configuration Release build
```

需要 Xcode 26.6+、macOS 26+。

---

## 技术说明

* 汉化以 `Localizable.strings` 为唯一文案来源，键是英文原文，值是简体中文。
* 新增 `Compositor/UI/LocalizedText.swift`，提供泛型函数 `zh()`，把模型层的 `String`
  （枚举名、状态标题、提示语）接入 SwiftUI 的本地化查表；查不到就原样显示英文，行为与英文版一致。
* 源码改动共 190 处，全部是「把值包进 `zh(…)`」，没有改任何逻辑、算法、文件格式或快捷键。
* `Config/Info.plist` 声明 `CFBundleDevelopmentRegion = zh-Hans`、`CFBundleLocalizations = [zh-Hans]`，
  这样在英文系统上也会显示中文。
* GitHub Actions 自动构建：每次推送 `main` 都会生成 `Compositor-<版本>-zh.<构建号>.zip`
  并挂到 `zh-latest` 预发布标签下，见 [构建中文版](.github/workflows/release-app.yml)。

## 校验

| 项目 | 结果 |
| --- | --- |
| 文案条目 | 1580 |
| `plutil -lint` | OK |
| 界面文案来源 | `Compositor/Resources/zh-Hans.lproj/Localizable.strings` |
| 应用包内路径 | `Compositor.app/Contents/Resources/zh-Hans.lproj/` |
| 上游基线 | `fc3c81a`（1.5.12） |

## 致谢与许可

本项目是 [robbietilton/Compositor](https://github.com/robbietilton/Compositor) 的汉化分支，
原项目采用 MIT 许可，版权归 Robbie Tilton 所有。汉化部分同样以 MIT 许可发布，见 [LICENSE](LICENSE)。
