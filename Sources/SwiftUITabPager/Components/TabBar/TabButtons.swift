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

    /// Exact width for each tab in fixed layout, once the bar has been measured.
    /// Pinning the width keeps a label that is wider than its share — a long title,
    /// or any title at an accessibility text size — from pushing the bar past the
    /// screen edge. nil until the first measurement pass.
    var fixedCellWidth: CGFloat? = nil

    var body: some View {
        HStack(spacing: layoutConfig.buttonSpacing) {
            ForEach(labelBuilders.indices, id: \.self) { index in

                Button {
                    withAnimation(.easeInOut) {
                        selectedIndex = index
                    }
                } label: {
                    label(at: index)
                }
                .buttonStyle(.plain)
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
                .accessibilityAddTraits(stateFor(index).isSelected ? .isSelected : [])
                .accessibilityValue("\(index + 1)/\(labelBuilders.count)")
                .id(index)
            }
        }
    }

    @ViewBuilder
    private func label(at index: Int) -> some View {
        let built = labelBuilders[index](stateFor(index))

        if isFixedWidth, let cellWidth = fixedCellWidth, cellWidth > 0 {
            built
                .frame(width: cellWidth, alignment: .center)
                // The cell owns its share of the bar — anything larger is cut
                // here rather than spilling over a neighbour or off screen
                .clipped()
                .contentShape(Rectangle())
        } else {
            built
                .frame(maxWidth: isFixedWidth ? .infinity : nil, alignment: .center)
                .contentShape(Rectangle())
        }
    }
}
