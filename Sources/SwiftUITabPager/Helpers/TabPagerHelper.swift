import Foundation

enum TabPagerHelper {

    static func clampIndex(_ index: Int, itemCount: Int) -> Int {
        guard itemCount > 0 else { return 0 }
        if index >= itemCount { return itemCount - 1 }
        if index < 0 { return 0 }
        return index
    }

    // Per-tab selection progress (0...1) interpolated from swipe progress
    static func selectionProgress(
        for index: Int,
        selectedIndex: Int,
        scrollProgress: CGFloat
    ) -> CGFloat {
        if index == selectedIndex {
            return 1 - min(abs(scrollProgress), 1)
        }
        if scrollProgress > 0, index == selectedIndex + 1 {
            return min(scrollProgress, 1)
        }
        if scrollProgress < 0, index == selectedIndex - 1 {
            return min(-scrollProgress, 1)
        }
        return 0
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
