import SwiftUI

/// A container view that renders a tab bar using either fixed-width or scrollable layout.
/// Switches internally between FixedTabBar and ScrollableTabBar based on the specified layout style.
struct TabBar<Label: View>: View {

    /// The array of tab label builders for custom views.
    let labelBuilders: [(TabState) -> Label]

    /// The currently selected tab index.
    @Binding var selectedIndex: Int

    /// Provides the selection state for each tab index.
    let stateFor: (Int) -> TabState

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
                labelBuilders: labelBuilders,
                selectedIndex: $selectedIndex,
                stateFor: stateFor,
                scrollProgress: scrollProgress,
                layoutConfig: layoutConfig,
                indicatorStyle: indicatorStyle
            )

        case .scrollable:
            ScrollableTabBar(
                labelBuilders: labelBuilders,
                selectedIndex: $selectedIndex,
                stateFor: stateFor,
                scrollProgress: scrollProgress,
                layoutConfig: layoutConfig,
                indicatorStyle: indicatorStyle
            )
        }
    }
}
