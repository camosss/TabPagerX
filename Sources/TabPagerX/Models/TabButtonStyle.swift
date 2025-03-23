import SwiftUI

/// Structure to hold TabButton styling properties
public struct TabButtonStyle: Sendable {
    public let normal: ButtonStateStyle
    public let selected: ButtonStateStyle
    public let padding: EdgeInsets
    public let cornerRadius: CGFloat
    public let indicatorStyle: TabIndicatorStyle

    /// Default style
    public static let `default` = TabButtonStyle(
        normal: ButtonStateStyle(
            font: .headline,
            textColor: .black,
            backgroundColor: .clear,
            borderColor: .clear,
            borderWidth: 0
        ),
        selected: ButtonStateStyle(
            font: .headline,
            textColor: .black,
            backgroundColor: .clear,
            borderColor: .clear,
            borderWidth: 0
        ),
        padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12),
        cornerRadius: 0,
        indicatorStyle: .default
    )

    /// Custom initializer with default values
    public init(
        normal: ButtonStateStyle,
        selected: ButtonStateStyle? = nil,
        padding: EdgeInsets? = nil,
        cornerRadius: CGFloat? = nil,
        indicatorStyle: TabIndicatorStyle? = nil
    ) {
        self.normal = normal
        self.selected = selected ?? normal
        self.padding = padding ?? Self.default.padding
        self.cornerRadius = cornerRadius ?? Self.default.cornerRadius
        self.indicatorStyle = indicatorStyle ?? Self.default.indicatorStyle
    }
}
