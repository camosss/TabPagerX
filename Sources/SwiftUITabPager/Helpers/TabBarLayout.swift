import CoreGraphics

/// Fixed tab bar sizing, kept pure so the arithmetic can be tested.
enum TabBarLayout {

    /// Width of a single tab when the bar splits its width equally.
    /// - Returns: nil when the bar has not been measured yet, or when padding and
    ///   spacing already consume everything, in which case the caller should fall
    ///   back to letting the labels size themselves.
    static func cellWidth(
        barWidth: CGFloat,
        tabCount: Int,
        buttonSpacing: CGFloat,
        sidePadding: CGFloat
    ) -> CGFloat? {
        guard barWidth > 0, tabCount > 0 else { return nil }

        let count = CGFloat(tabCount)
        let spacing = buttonSpacing * max(count - 1, 0)
        let usable = barWidth - sidePadding * 2 - spacing
        guard usable > 0 else { return nil }

        return usable / count
    }

    /// Whether a label needs more room than its tab has.
    /// A half point of slack keeps rounding noise from tripping the check.
    static func isOverflowing(naturalLabelWidth: CGFloat, cellWidth: CGFloat?) -> Bool {
        guard let cellWidth, cellWidth > 0 else { return false }
        return naturalLabelWidth > cellWidth + 0.5
    }
}
