import SwiftUI

/// A horizontally scrollable tab bar with animated indicator.
struct ScrollableTabBar<TabTitle: View>: View {

    let tabTitleBuilders: [(_ isSelected: Bool) -> TabTitle]
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
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    TabButtons(
                        tabTitleBuilders: tabTitleBuilders,
                        selectedIndex: $selectedIndex,
                        layoutConfig: layoutConfig,
                        isFixedWidth: false
                    )
                    .padding(.horizontal, layoutConfig.sidePadding)
                    .onChange(of: selectedIndex) { newIndex in
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(newIndex, anchor: .center)
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
