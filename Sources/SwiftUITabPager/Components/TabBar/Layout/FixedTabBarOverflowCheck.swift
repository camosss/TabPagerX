import SwiftUI

/// Warns, in debug builds only, when a fixed tab bar cannot fit its labels.
///
/// The fixed layout hands every tab an equal share of the bar, so a long title —
/// or any title once the user raises the text size — no longer fits and gets
/// clipped. That is easy to miss on the one device you test on, so measure the
/// labels at their natural size and say so.
///
/// In release builds this modifier does nothing.
struct FixedTabBarOverflowCheck<Label: View>: ViewModifier {

    let labelBuilders: [(TabState) -> Label]
    let stateFor: (Int) -> TabState
    let layoutConfig: TabBarLayoutConfig
    let cellWidth: CGFloat?

    func body(content: Content) -> some View {
        #if DEBUG
        content.background(measuringLabels)
        #else
        content
        #endif
    }

    #if DEBUG
    private var measuringLabels: some View {
        HStack(spacing: 0) {
            ForEach(labelBuilders.indices, id: \.self) { index in
                labelBuilders[index](stateFor(index))
                    // Ideal size regardless of what the bar proposes
                    .fixedSize()
                    .background(
                        GeometryReader { proxy in
                            Color.clear.preference(
                                key: NaturalLabelWidthPreferenceKey.self,
                                value: proxy.size.width
                            )
                        }
                    )
            }
        }
        .hidden()
        .onPreferenceChange(NaturalLabelWidthPreferenceKey.self) { widest in
            report(widest: widest)
        }
    }

    private func report(widest: CGFloat) {
        guard TabBarLayout.isOverflowing(naturalLabelWidth: widest, cellWidth: cellWidth),
              let cellWidth else { return }

        TabPagerWarning.once(
            """
            A tab label needs \(Int(widest.rounded()))pt but the fixed tab bar only has \
            \(Int(cellWidth.rounded()))pt per tab, so it is being clipped. Switch to \
            .tabBarLayoutStyle(.scrollable), use shorter titles, or add \
            .lineLimit(1).minimumScaleFactor(0.7) to your label.
            """
        )
    }
    #endif
}

#if DEBUG
struct NaturalLabelWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
#endif
