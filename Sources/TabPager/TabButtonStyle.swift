import SwiftUI

/// Structure to hold TabButton styling properties
public struct TabButtonStyle: Sendable {
    public let normal: ButtonStateStyle
    public let selected: ButtonStateStyle
    public let padding: EdgeInsets
    public let borderColor: Color
    public let borderWidth: CGFloat
    public let cornerRadius: CGFloat
    public let indicatorStyle: TabIndicatorStyle

    /// Default style
    public static let `default` = TabButtonStyle(
        normal: ButtonStateStyle(
            font: .headline,
            textColor: .black,
            backgroundColor: .clear
        ),
        selected: ButtonStateStyle(
            font: .headline,
            textColor: .black,
            backgroundColor: .clear
        ),
        padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12),
        borderColor: .clear,
        borderWidth: 0,
        cornerRadius: 0,
        indicatorStyle: .default
    )

    /// Custom initializer with default values
    public init(
        normal: ButtonStateStyle,
        selected: ButtonStateStyle? = nil,
        padding: EdgeInsets? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat? = nil,
        cornerRadius: CGFloat? = nil,
        indicatorStyle: TabIndicatorStyle? = nil
    ) {
        self.normal = normal
        self.selected = selected ?? normal
        self.padding = padding ?? Self.default.padding
        self.borderColor = borderColor ?? Self.default.borderColor
        self.borderWidth = borderWidth ?? Self.default.borderWidth
        self.cornerRadius = cornerRadius ?? Self.default.cornerRadius
        self.indicatorStyle = indicatorStyle ?? Self.default.indicatorStyle
    }
}
