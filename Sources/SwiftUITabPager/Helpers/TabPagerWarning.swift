#if DEBUG
import Foundation

/// Debug-build diagnostics. Each distinct message is printed once per run so a
/// warning raised during layout does not repeat on every pass.
enum TabPagerWarning {

    private static var delivered = Set<String>()

    static func once(_ message: String) {
        guard !delivered.contains(message) else { return }
        delivered.insert(message)
        print("[SwiftUITabPager] \(message)")
    }
}
#endif
