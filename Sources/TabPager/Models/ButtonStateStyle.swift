import SwiftUI

/// Structure to hold styling properties for a specific button state (normal or selected)
public struct ButtonStateStyle: Sendable {
    public let font: Font
    public let textColor: Color
    public let backgroundColor: Color

    public init(
        font: Font,
        textColor: Color,
        backgroundColor: Color
    ) {
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}
