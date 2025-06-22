import SwiftUI

public extension View {
    func tabTitle(_ title: String) -> TabPagerItem {
        TabPagerItem(view: self, title: title)
    }
}
