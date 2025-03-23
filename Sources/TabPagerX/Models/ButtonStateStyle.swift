import SwiftUI

/// Structure to hold styling properties for a specific button state (normal or selected)
public struct ButtonStateStyle: Sendable {
    public let font: Font
    public let textColor: Color
    public let backgroundColor: Color
    public let borderColor: Color?
    public let borderWidth: CGFloat?

    public init(
        font: Font,
        textColor: Color,
        backgroundColor: Color,
        borderColor: Color? = nil,
        borderWidth: CGFloat? = nil
    ) {
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
}
