import SwiftUI

/// 把界面文案变成可本地化的 `LocalizedStringKey`。
///
/// SwiftUI 只在 `Text("…")` 这类字面量上查 `Localizable.strings`；而 Compositor 里有大量文案来自模型层
/// （图层混合模式名、滤镜名、工具说明、状态化的菜单标题、提示语等）的 `String`。用 `zh(…)` 把它们包起来，
/// 中文版就能按英文原文查表显示简体中文；表里没有的键原样显示英文，与改动前完全一致。
///
/// 传进来的值可能是 `String`、`String?`（例如 `session.importError`）或本身就是 `LocalizedStringKey`，
/// 因此这里做成泛型，调用点不必纠结类型。空值显示为空，不会出现 “nil”。
@inline(__always)
func zh<T>(_ value: T) -> LocalizedStringKey {
    if let key = value as? LocalizedStringKey { return key }
    if let text = value as? String { return LocalizedStringKey(text) }
    if let optional = value as? String? { return LocalizedStringKey(optional ?? "") }
    let described = String(describing: value)
    return LocalizedStringKey(described == "nil" ? "" : described)
}

/// AppKit 侧的文案（浮动面板标题、窗口标题等）不是 SwiftUI 的 `Text`，走这个查表取中文，查不到返回原文。
func zhString(_ key: String) -> String {
    Bundle.main.localizedString(forKey: key, value: key, table: nil)
}

extension String {
    /// 字符串版本，便于拼接后再本地化：`("Last Filter: " + filter.rawValue).zh`。
    var zh: LocalizedStringKey { LocalizedStringKey(self) }
}
