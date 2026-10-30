import SwiftUI

/// 把界面文案变成可本地化的 `LocalizedStringKey`。
///
/// SwiftUI 只在 `Text("…")` 这类字面量上查 `Localizable.strings`；而 Compositor 里有大量文案来自模型层
/// （图层混合模式名、滤镜名、工具说明、提示语等）的 `String`。用 `zh(…)` 把它们包起来，中文版就能按英文原文
/// 查表显示简体中文，英文原文查不到时原样显示，行为与改动前一致。
///
/// 传进来的值可能是 `String`、`String?`（例如 `session.importError`）或本身就是 `LocalizedStringKey`，
/// 所以这里做成泛型，避免在每个调用点纠结类型。
@inline(__always)
func zh<T>(_ value: T) -> LocalizedStringKey {
    if let key = value as? LocalizedStringKey { return key }
    if let text = value as? String { return LocalizedStringKey(text) }
    if let optional = value as? String?, let text = optional { return LocalizedStringKey(text) }
    return LocalizedStringKey(String(describing: value))
}

extension String {
    /// 字符串版本，便于拼接后再本地化：`("Last Filter: " + filter.rawValue).zh`。
    var zh: LocalizedStringKey { LocalizedStringKey(self) }
}
