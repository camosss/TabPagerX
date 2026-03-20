import SwiftUI

/// A bottom-aligned capsule-shaped indicator that animates beneath the selected tab.
/// This view adjusts its size and position based on the provided frame and styling.
struct TabIndicator: View {

    /// The frame of the currently selected tab button.
    let frame: CGRect

    /// Visual style for the indicator (color, height, insets, animation).
    let style: TabIndicatorStyle

    var body: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius)
            .fill(style.color)
            .frame(
                width: max(frame.width - 2 * style.horizontalInset, 0),
                height: style.height
            )
            .offset(
                x: frame.minX + style.horizontalInset,
                y: 0
            )
            .allowsHitTesting(false)
    }
}
