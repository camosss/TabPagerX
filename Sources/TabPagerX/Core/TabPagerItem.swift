import SwiftUI

public struct TabPagerItem {
    let view: AnyView
    let title: String

    public init<V: View>(view: V, title: String) {
        self.view = AnyView(view)
        self.title = title
    }
}
