import SwiftUI

// Structure to hold TabButton styling properties
public struct TabButtonStyle: Sendable {
    public let font: Font
    public let textColor: Color
    public let selectedTextColor: Color
    public let backgroundColor: Color
    public let selectedBackgroundColor: Color
    public let padding: EdgeInsets

    // Default style
    public static let `default` = TabButtonStyle(
        font: .headline,
        textColor: .black,
        selectedTextColor: .black,
        backgroundColor: .clear,
        selectedBackgroundColor: .blue,
        padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
    )
}
