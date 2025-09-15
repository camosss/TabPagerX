import SwiftUI

/// A horizontal tab bar with fixed spacing and animated indicator movement.
/// This view tracks the position of each tab button and renders an indicator aligned
/// to the currently selected tab using shared coordinate space.
struct FixedTabBarView: View {

    @Binding var tabs: [String]
    let titleBuilders: [() -> AnyView]
    @Binding var selectedIndex: Int

    let layoutConfig: TabBarLayoutConfig
    let buttonStyle: TabButtonStyle
    let indicatorStyle: TabIndicatorStyle

    /// Stores the screen-space frames of all tab buttons, used to align the indicator.
    @State private var tabFrames: [Int: CGRect] = [:]

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Render the horizontal list of tab buttons
            TabButtonList(
                tabs: tabs,
                titleBuilders: titleBuilders,
                selectedIndex: $selectedIndex,
                buttonStyle: buttonStyle,
                layoutConfig: layoutConfig
            )
            .padding(.horizontal, layoutConfig.sidePadding)
            .frame(maxWidth: .infinity)
            .onPreferenceChange(TabItemPreferenceKey.self) { value in
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

