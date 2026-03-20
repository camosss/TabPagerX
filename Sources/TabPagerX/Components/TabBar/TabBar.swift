import SwiftUI

/// A container view that renders a tab bar using either fixed-width or scrollable layout.
/// Switches internally between FixedTabBar and ScrollableTabBar based on the specified layout style.
struct TabBar<TabTitle: View>: View {

    /// The array of tab title builders for custom views.
    let tabTitleBuilders: [(_ isSelected: Bool) -> TabTitle]

    /// The currently selected tab index.
    @Binding var selectedIndex: Int

    /// The visually highlighted tab index (follows scroll progress).
    let displayIndex: Int

    /// Continuous scroll progress from page swipe (-1 to 1).
    let scrollProgress: CGFloat

    /// The layout style for tabs (fixed or scrollable).
    let layoutStyle: TabLayoutStyle

    /// Configuration for layout settings like spacing and padding.
    let layoutConfig: TabBarLayoutConfig

    /// Style configuration for the selection indicator.
    let indicatorStyle: TabIndicatorStyle

    var body: some View {
        switch layoutStyle {

        case .fixed:
            FixedTabBar(
                tabTitleBuilders: tabTitleBuilders,
                selectedIndex: $selectedIndex,
                displayIndex: displayIndex,
                scrollProgress: scrollProgress,
                layoutConfig: layoutConfig,
                indicatorStyle: indicatorStyle
            )

        case .scrollable:
            ScrollableTabBar(
                tabTitleBuilders: tabTitleBuilders,
                selectedIndex: $selectedIndex,
                displayIndex: displayIndex,
                scrollProgress: scrollProgress,
                layoutConfig: layoutConfig,
                indicatorStyle: indicatorStyle
            )
        }
    }
}
