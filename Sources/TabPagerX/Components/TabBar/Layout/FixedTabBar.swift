import SwiftUI

/// A horizontal tab bar with fixed spacing and animated indicator movement.
/// This view tracks the position of each tab button and renders an indicator aligned
/// to the currently selected tab using shared coordinate space.
struct FixedTabBar: View {

    let tabTitleBuilders: [(_ isSelected: Bool) -> AnyView]
    @Binding var selectedIndex: Int

    let layoutConfig: TabBarLayoutConfig
    let indicatorStyle: TabIndicatorStyle

    /// Stores the screen-space frames of all tab buttons, used to align the indicator.
    @State private var tabFrames: [Int: CGRect] = [:]

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            // Render the horizontal list of tab buttons
            TabButtons(
                tabTitleBuilders: tabTitleBuilders,
                selectedIndex: $selectedIndex,
                layoutConfig: layoutConfig,
                isFixedWidth: true
            )
            .padding(.horizontal, layoutConfig.sidePadding)
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
        // Defines a named coordinate space for consistent frame measurement
        .coordinateSpace(name: CoordinateSpaces.tabBar)
        .frame(maxWidth: .infinity)
    }
}
