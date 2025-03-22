import SwiftUI

// Structure to hold TabButton styling properties
public struct TabButtonStyle: Sendable {
    public let font: Font
    public let textColor: Color
    public let selectedTextColor: Color
    public let backgroundColor: Color
    public let selectedBackgroundColor: Color
    public let padding: EdgeInsets
    public let borderColor: Color
    public let borderWidth: CGFloat
    public let cornerRadius: CGFloat
    public let indicatorStyle: TabIndicatorStyle

    // Default style
    public static let `default` = TabButtonStyle(
        font: .headline,
        textColor: .black,
        selectedTextColor: .black,
        backgroundColor: .clear,
        selectedBackgroundColor: .blue,
        padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12),
        borderColor: .clear,
        borderWidth: 0,
        cornerRadius: 0,
        indicatorStyle: .default
    )
}
