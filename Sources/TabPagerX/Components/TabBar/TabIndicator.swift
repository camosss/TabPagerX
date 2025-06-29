import SwiftUI

/// A bottom-aligned capsule-shaped indicator that animates beneath the selected tab.
/// This view adjusts its size and position based on the provided frame and styling.
struct TabIndicator: View {

    /// The frame of the currently selected tab button.
    let frame: CGRect

    /// Visual style for the indicator (color, height, insets, animation).
    let style: TabIndicatorStyle

    /// The index of the currently selected tab. Triggers animation when changed.
    let selectedIndex: Int

    var body: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius)
            .fill(style.color)
            .frame(
                // Indicator width accounts for horizontal insets
                width: max(frame.width - 2 * style.horizontalInset, 0),
                height: style.height
            )
            .offset(
                // Align indicator under the selected tab using its frame
                x: frame.minX + style.horizontalInset,
                y: 0
            )
            .animation(
                // Smooth animation when the selected index changes
                .easeInOut(duration: style.animationDuration),
                value: selectedIndex
            )
            .allowsHitTesting(false) // Ignore touches on the indicator
    }
}

