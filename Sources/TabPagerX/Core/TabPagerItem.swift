import SwiftUI

public struct TabPagerItem {
    let view: AnyView
    let titleBuilder: () -> AnyView

    public init<V: View, T: View>(
        view: V,
        @ViewBuilder titleView: @escaping () -> T
    ) {
        self.view = AnyView(view)
        self.titleBuilder = { AnyView(titleView()) }
    }
}
