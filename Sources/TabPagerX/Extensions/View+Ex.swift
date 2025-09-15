import SwiftUI

public extension View {
    func tabTitle(_ title: String) -> TabPagerItem {
        TabPagerItem(view: self, title: title)
    }
    
    func tabTitle<T: View>(@ViewBuilder _ titleView: @escaping () -> T) -> TabPagerItem {
        TabPagerItem(view: self, titleView: titleView)
    }
}
