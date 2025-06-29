import SwiftUI

/// A reusable horizontal list of tab buttons that updates the selected index on tap.
/// Also reports button frames using PreferenceKey for indicator alignment.
struct TabButtonList: View {

    let tabs: [String]
    @Binding var selectedIndex: Int

    let buttonStyle: TabButtonStyle
    let layoutConfig: TabBarLayoutConfig

    var body: some View {
        // Horizontal stack of tab buttons
        HStack(spacing: layoutConfig.buttonSpacing) {
            ForEach(tabs.indices, id: \.self) { index in
                TabButton(
                    title: tabs[index],
                    isSelected: index == selectedIndex,
                    buttonStyle: buttonStyle
                )
                .background(
                    // Capture each button's frame to align the indicator later
                    GeometryReader { proxy in
                        Color.clear.preference(
                            key: TabItemPreferenceKey.self,
                            value: [index: proxy.frame(
                                in: .named(CoordinateSpaces.tabBar)
                            )]
                        )
                    }
                )
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selectedIndex = index
                    }
                }
                .id(index)
            }
        }
    }
}
