import SwiftUI

/// A reusable horizontal list of tab buttons that updates the selected index on tap.
/// Also reports button frames using PreferenceKey for indicator alignment.
struct TabButtonList: View {

    let titleBuilders: [(_ isSelected: Bool) -> AnyView]
    @Binding var selectedIndex: Int

    let layoutConfig: TabBarLayoutConfig
    /// When true, each tab occupies equal width (used in fixed layout). When false, content-sized.
    let distributeEqually: Bool

    var body: some View {
        // Horizontal stack of tab buttons
        HStack(spacing: layoutConfig.buttonSpacing) {
            ForEach(titleBuilders.indices, id: \.self) { index in
                titleBuilders[index](index == selectedIndex)
                    .frame(maxWidth: distributeEqually ? .infinity : nil, alignment: .center)
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
