import SwiftUI

/// A horizontal tab bar with fixed-width tabs and animated indicator.
struct FixedTabBar<Label: View>: View {

    let labelBuilders: [(TabState) -> Label]
    @Binding var selectedIndex: Int
    let stateFor: (Int) -> TabState
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
                labelBuilders: labelBuilders,
                selectedIndex: $selectedIndex,
                stateFor: stateFor,
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
