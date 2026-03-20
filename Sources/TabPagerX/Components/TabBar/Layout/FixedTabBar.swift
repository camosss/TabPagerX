import SwiftUI

/// A horizontal tab bar with fixed-width tabs and animated indicator.
struct FixedTabBar: View {

    let tabTitleBuilders: [(_ isSelected: Bool) -> AnyView]
    @Binding var selectedIndex: Int
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
