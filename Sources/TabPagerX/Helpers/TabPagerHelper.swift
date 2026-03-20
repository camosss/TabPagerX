import Foundation

enum TabPagerHelper {

    static func clampIndex(_ index: Int, itemCount: Int) -> Int {
        guard itemCount > 0 else { return 0 }
        if index >= itemCount { return itemCount - 1 }
        if index < 0 { return 0 }
        return index
    }

    static func displayIndex(
        selectedIndex: Int,
        scrollProgress: CGFloat,
        itemCount: Int
    ) -> Int {
        if scrollProgress > 0.5, selectedIndex + 1 < itemCount {
            return selectedIndex + 1
        } else if scrollProgress < -0.5, selectedIndex - 1 >= 0 {
            return selectedIndex - 1
        }
        return selectedIndex
    }
}
