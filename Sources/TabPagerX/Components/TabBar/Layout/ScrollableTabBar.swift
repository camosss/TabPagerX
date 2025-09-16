import SwiftUI

/// A horizontally scrollable tab bar with animated indicator.
/// Each tab adjusts its width based on content and scrolls into view when selected.
/// Uses preference keys to track button positions and position the indicator.
struct ScrollableTabBar: View {

    let tabTitleBuilders: [(_ isSelected: Bool) -> AnyView]
    @Binding var selectedIndex: Int

    let layoutConfig: TabBarLayoutConfig
    let indicatorStyle: TabIndicatorStyle

    /// Stores the screen-space frames of all tab buttons, used to align the indicator.
    @State private var tabFrames: [Int: CGRect] = [:]

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            // Scrollable row of tab buttons
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
            .onPreferenceChange(TabButtonPreferenceKey.self) { value in
                // Update tabFrames with button positions whenever layout changes
                tabFrames = value
            }

            // Animated indicator under the selected tab
            if let frame = tabFrames[selectedIndex],
                !tabFrames.isEmpty {

                TabIndicator(
                    frame: frame,
                    style: indicatorStyle,
                    selectedIndex: selectedIndex
                )
            }
        }
        .frame(maxWidth: .infinity)
    }
}
