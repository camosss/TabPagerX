import SwiftUI

/// A container view that renders a tab bar using either fixed-width or scrollable layout.
/// Switches internally between FixedTabBar and ScrollableTabBar based on the specified layout style.
struct TabBar: View {

    /// The array of tab title builders for custom views.
    let tabTitleBuilders: [(_ isSelected: Bool) -> AnyView]

    /// The currently selected tab index.
    @Binding var selectedIndex: Int

    /// The layout style for tabs (fixed or scrollable).
    let layoutStyle: TabLayoutStyle

    /// Configuration for layout settings like spacing and padding.
    let layoutConfig: TabBarLayoutConfig

    /// Style configuration for the selection indicator.
    let indicatorStyle: TabIndicatorStyle

    var body: some View {
        switch layoutStyle {

        // Distributes all tabs evenly across the full width
        case .fixed:
            FixedTabBar(
                tabTitleBuilders: tabTitleBuilders,
                selectedIndex: $selectedIndex,
                layoutConfig: layoutConfig,
                indicatorStyle: indicatorStyle
            )

        // Sizes tabs according to content and allows horizontal scrolling
        case .scrollable:
            ScrollableTabBar(
                tabTitleBuilders: tabTitleBuilders,
                selectedIndex: $selectedIndex,
                layoutConfig: layoutConfig,
                indicatorStyle: indicatorStyle
            )
        }
    }
}
