import SwiftUI

/// A horizontally scrollable tab bar with animated indicator.
/// Each tab adjusts its width based on content and scrolls into view when selected.
/// Uses preference keys to track button positions and position the indicator.
struct ScrollableTabBar: View {

    let tabTitleBuilders: [(_ isSelected: Bool) -> AnyView]
    @Binding var selectedIndex: Int
    let scrollProgress: CGFloat

    let layoutConfig: TabBarLayoutConfig
    let indicatorStyle: TabIndicatorStyle

    /// Stores the screen-space frames of all tab buttons, used to align the indicator.
    @State private var tabFrames: [Int: CGRect] = [:]

    private var indicatorFrame: CGRect {
        guard let current = tabFrames[selectedIndex] else { return .zero }
        guard scrollProgress != 0 else { return current }

        let targetIndex = scrollProgress > 0 ? selectedIndex + 1 : selectedIndex - 1
        guard let target = tabFrames[targetIndex] else { return current }

        let p = abs(scrollProgress)
        return CGRect(
            x: current.origin.x + (target.origin.x - current.origin.x) * p,
            y: current.origin.y,
            width: current.width + (target.width - current.width) * p,
            height: current.height
        )
    }

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
            if !tabFrames.isEmpty {
                TabIndicator(
                    frame: indicatorFrame,
                    style: indicatorStyle
                )
                .animation(
                    scrollProgress == 0
                        ? .easeInOut(duration: indicatorStyle.animationDuration)
                        : .none,
                    value: selectedIndex
                )
            }
        }
        .frame(maxWidth: .infinity)
    }
}
