import SwiftUI

/// A horizontal tab bar with fixed-width tabs and animated indicator.
struct FixedTabBar<TabTitle: View>: View {

    let tabTitleBuilders: [(_ isSelected: Bool) -> TabTitle]
    @Binding var selectedIndex: Int
    let displayIndex: Int
    let scrollProgress: CGFloat

    let layoutConfig: TabBarLayoutConfig
    let indicatorStyle: TabIndicatorStyle

    var body: some View {
        TabBarContainer(
            selectedIndex: $selectedIndex,
            scrollProgress: scrollProgress,
            indicatorStyle: indicatorStyle
        ) {
            TabButtons(
                tabTitleBuilders: tabTitleBuilders,
                selectedIndex: $selectedIndex,
                displayIndex: displayIndex,
                layoutConfig: layoutConfig,
                isFixedWidth: true
            )
            .padding(.horizontal, layoutConfig.sidePadding)
            .frame(maxWidth: .infinity)
        }
        .coordinateSpace(name: CoordinateSpaces.tabBar)
        .frame(maxWidth: .infinity)
    }
}
