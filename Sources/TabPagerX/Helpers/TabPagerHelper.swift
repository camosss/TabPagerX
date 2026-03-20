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
        guard itemCount > 0 else { return 0 }
        let clamped = clampIndex(selectedIndex, itemCount: itemCount)
        if scrollProgress > 0.5, clamped + 1 < itemCount {
            return clamped + 1
        } else if scrollProgress < -0.5, clamped - 1 >= 0 {
            return clamped - 1
        }
        return clamped
    }
}
