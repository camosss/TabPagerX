import SwiftUI

public extension View {
    func tabTitle<T: View>(
        @ViewBuilder _ titleView: @escaping () -> T
    ) -> TabPagerItem {
        TabPagerItem(view: self, titleView: titleView)
    }
}
