import SwiftUI

/// Shared container that manages tab button frame tracking and indicator rendering.
/// Used by both FixedTabBar and ScrollableTabBar to avoid duplication.
struct TabBarContainer<Content: View>: View {

    @Binding var selectedIndex: Int
    let scrollProgress: CGFloat
    let indicatorStyle: TabIndicatorStyle
    @ViewBuilder let content: Content

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
            content
                .onPreferenceChange(TabButtonPreferenceKey.self) { value in
                    tabFrames = value
                }

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
    }
}
