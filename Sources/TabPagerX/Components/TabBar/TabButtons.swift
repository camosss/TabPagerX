import SwiftUI

/// A reusable horizontal list of tab buttons that updates the selected index on tap.
/// Also reports button frames using PreferenceKey for indicator alignment.
struct TabButtons: View {

    let tabTitleBuilders: [(_ isSelected: Bool) -> AnyView]
    @Binding var selectedIndex: Int

    let layoutConfig: TabBarLayoutConfig
    
    /// When true, each tab occupies equal width (used in fixed layout). When false, content-sized.
    let isFixedWidth: Bool

    var body: some View {
        // Horizontal stack of tab buttons
        HStack(spacing: layoutConfig.buttonSpacing) {
            ForEach(tabTitleBuilders.indices, id: \.self) { index in

                tabTitleBuilders[index](index == selectedIndex)
                    .frame(maxWidth: isFixedWidth ? .infinity : nil, alignment: .center)
                    .background(
                        // Capture each button's frame to align the indicator later
                        GeometryReader { proxy in
                            Color.clear.preference(
                                key: TabButtonPreferenceKey.self,
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
