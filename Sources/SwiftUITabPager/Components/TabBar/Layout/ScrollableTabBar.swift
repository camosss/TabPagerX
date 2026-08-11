import SwiftUI

/// A horizontally scrollable tab bar with animated indicator.
struct ScrollableTabBar<Label: View>: View {

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
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    TabButtons(
                        labelBuilders: labelBuilders,
                        selectedIndex: $selectedIndex,
                        stateFor: stateFor,
                        layoutConfig: layoutConfig,
                        isFixedWidth: false
                    )
                    .padding(.horizontal, layoutConfig.sidePadding)
                    .onAppear {
                        // Center the selected tab on first appearance —
                        // a preset selection may otherwise start offscreen
                        guard selectedIndex > 0 else { return }
                        proxy.scrollTo(selectedIndex, anchor: .center)
                    }
                    .onChangeCompat(of: selectedIndex) {
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(selectedIndex, anchor: .center)
                        }
                    }
                }
            }
            .coordinateSpace(name: CoordinateSpaces.tabBar)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}
