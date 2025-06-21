import SwiftUI

extension View {
    func tabTitle(_ title: String) -> TabPagerItem<Self> {
        TabPagerItem(view: self, title: title)
    }
}
