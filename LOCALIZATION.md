# 汉化维护说明

## 一、文案放在哪

```
Compositor/Resources/zh-Hans.lproj/
├── Localizable.strings   # 界面文案：键是英文原文，值是简体中文
└── InfoPlist.strings     # 应用名（菜单栏、关于窗口、访达里显示的名字）
```

Xcode 工程用的是「文件夹同步」组（`PBXFileSystemSynchronizedRootGroup`），
所以往这个目录里加文件、加语言不需要改 `project.pbxproj`，构建时会自动打进 `Compositor.app/Contents/Resources/`。

## 二、中文是怎么生效的

SwiftUI 只在 `Text("…")`、`Button("…")` 这类**字面量**上去查 `Localizable.strings`。
Compositor 里还有大量文案来自模型层，例如：

```swift
Text(tool.label)                 // 工具提示，String
Button(kind.rawValue + "…")      // 滤镜菜单，String 拼接
Text(session.mergeTitle)         // 菜单项，随状态变化
```

这类文本本来不走本地化，所以加了一个泛型小函数 `zh()`（`Compositor/UI/LocalizedText.swift`）：

```swift
@inline(__always)
func zh<T>(_ value: T) -> LocalizedStringKey
```

调用点只是把值包一层：`Text(zh(tool.label))`。它把值当成英文原文去查表，查不到就原样返回，
所以**英文版和中文版的行为完全一致**，只是显示语言不同。这也是整个汉化里唯一碰代码的地方，
一共 189 处，全部是「包一层」的机械改动。

`Config/Info.plist` 里：

* `CFBundleDevelopmentRegion = zh-Hans`、`CFBundleLocalizations = [zh-Hans]`：让应用在英文系统上也显示中文。
* `SUEnableAutomaticChecks = false`：中文版的文案是打包进 `.app` 的，上游自动更新会用英文版覆盖掉它，
  所以默认关闭自动检查，仍可在菜单里手动「检查更新…」。
* `CFBundleDisplayName = Compositor 中文版`：访达和菜单栏里的名字。

## 三、文案是怎么写出来的

1. 扫源码里所有 Swift 字符串字面量（约 2100 条），按上下文筛掉键名、路径、UTI、系统符号名等非文案。
2. 按 Photoshop 简体中文版的术语统一翻译（见词表），逐条人工校对。
3. 带插值的文案要注意键的形态：SwiftUI 会把 `\(Int)` 变成 `%lld`、`\(Double)` 变成 `%lf`、`\(String)` 变成 `%@`。
   例如源码 `Text("Current: \(w) × \(h) pixels")` 的键是 `"Current: %lld × %lld pixels"`。
4. 枚举名拼出来的菜单项（如 `kind.rawValue + "…"`、`"Last Filter: " + name`）按枚举逐条列出，
   避免运行时拼出表里没有的键。

## 四、常见术语对照

| 英文 | 中文 | 英文 | 中文 |
| --- | --- | --- | --- |
| layer | 图层 | mask | 蒙版 |
| selection | 选区 | clipping mask | 剪贴蒙版 |
| adjustment layer | 调整图层 | blend mode | 混合模式 |
| Levels | 色阶 | Curves | 曲线 |
| Hue/Saturation | 色相/饱和度 | Gradient Map | 渐变映射 |
| Black & White | 黑白 | Color Balance | 色彩平衡 |
| Gaussian Blur | 高斯模糊 | Vignette | 晕影 |
| Multiply | 正片叠底 | Screen | 滤色 |
| Overlay | 叠加 | Soft Light | 柔光 |
| Merge Down | 向下合并 | Merge Layers | 合并图层 |
| Feather | 羽化 | Tolerance | 容差 |

Camera Raw、Photoshop、PSD、PNG、JPEG、GIF、CMYK、RGB、sRGB、HDR、EXR、GPU 等专有名词保持原样。

## 五、加新文案

1. 在 `Localizable.strings` 末尾加一行：`"英文原文" = "简体中文";`，注意分号、引号转义，`%lld`/`%@` 必须和原文一一对应。
2. 检查语法：`plutil -lint Compositor/Resources/zh-Hans.lproj/Localizable.strings`。
3. 如果文案来自动态拼接，确认拼接后的完整字符串也在表里（例如 `"Last Filter: " + name` 对应 `"Last Filter: 高斯模糊"`）。
4. 推送 `main`，GitHub Actions 会自动构建并把新包挂到 `zh-latest`。

## 六、验证

```sh
plutil -lint Compositor/Resources/zh-Hans.lproj/Localizable.strings
grep -c '";' Compositor/Resources/zh-Hans.lproj/Localizable.strings   # 条目数
```

构建后确认 `Compositor.app/Contents/Resources/zh-Hans.lproj/` 存在，且 `Info.plist` 的
`CFBundleDevelopmentRegion` 是 `zh-Hans`。
