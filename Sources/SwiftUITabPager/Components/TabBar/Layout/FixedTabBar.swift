import SwiftUI

/// A horizontal tab bar with fixed-width tabs and animated indicator.
struct FixedTabBar<Label: View>: View {

    let labelBuilders: [(TabState) -> Label]
    @Binding var selectedIndex: Int
    let stateFor: (Int) -> TabState
    let scrollProgress: CGFloat

    let layoutConfig: TabBarLayoutConfig
    let indicatorStyle: TabIndicatorStyle

    /// Width available to the whole bar, measured on the first layout pass
    @State private var barWidth: CGFloat = 0

    /// Width each tab gets once the bar has been measured
    private var cellWidth: CGFloat? {
        TabBarLayout.cellWidth(
            barWidth: barWidth,
            tabCount: labelBuilders.count,
            buttonSpacing: layoutConfig.buttonSpacing,
            sidePadding: layoutConfig.sidePadding
        )
    }

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
                isFixedWidth: true,
                fixedCellWidth: cellWidth
            )
            .padding(.horizontal, layoutConfig.sidePadding)
            .frame(maxWidth: .infinity)
            // Measured in the background so the bar keeps its intrinsic height
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: TabBarWidthPreferenceKey.self,
                        value: proxy.size.width
                    )
                }
            )
            .onPreferenceChange(TabBarWidthPreferenceKey.self) { width in
                barWidth = width
            }
            .modifier(
                FixedTabBarOverflowCheck(
                    labelBuilders: labelBuilders,
                    stateFor: stateFor,
                    layoutConfig: layoutConfig,
                    cellWidth: cellWidth
                )
            )
        }
        .coordinateSpace(name: CoordinateSpaces.tabBar)
        .frame(maxWidth: .infinity)
    }
}

struct TabBarWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
