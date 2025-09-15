import SwiftUI

public extension View {
    func tabTitle<T: View>(
        @ViewBuilder _ titleView: @escaping () -> T
    ) -> TabPagerItem {
        TabPagerItem(view: self, titleView: titleView)
    }

    func tabTitle<T: View>(
        @ViewBuilder _ titleView: @escaping (_ isSelected: Bool) -> T
    ) -> TabPagerItem {
        TabPagerItem(view: self, titleView: titleView)
    }
}
