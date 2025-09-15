import SwiftUI

public struct TabPagerItem {
    let view: AnyView
    let titleBuilder: (_ isSelected: Bool) -> AnyView

    public init<V: View, T: View>(
        view: V,
        @ViewBuilder titleView: @escaping (_ isSelected: Bool) -> T
    ) {
        self.view = AnyView(view)
        self.titleBuilder = { isSelected in AnyView(titleView(isSelected)) }
    }

    // Convenience initializer for callers that don't need selection state
    public init<V: View, T: View>(
        view: V,
        @ViewBuilder titleView: @escaping () -> T
    ) {
        self.view = AnyView(view)
        self.titleBuilder = { _ in AnyView(titleView()) }
    }
}
