import SwiftUI

/// A reusable horizontal list of tab buttons that updates the selected index on tap.
/// Also reports button frames using PreferenceKey for indicator alignment.
struct TabButtons<Label: View>: View {

    let labelBuilders: [(TabState) -> Label]
    @Binding var selectedIndex: Int
    let stateFor: (Int) -> TabState

    let layoutConfig: TabBarLayoutConfig

    /// When true, each tab occupies equal width (used in fixed layout). When false, content-sized.
    let isFixedWidth: Bool

    var body: some View {
        HStack(spacing: layoutConfig.buttonSpacing) {
            ForEach(labelBuilders.indices, id: \.self) { index in

                labelBuilders[index](stateFor(index))
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
