import SwiftUI

/// Structure to hold tab indicator styling properties
public struct TabIndicatorStyle: Sendable {
    public let height: CGFloat
    public let color: Color
    public let horizontalInset: CGFloat
    public let cornerRadius: CGFloat
    public let animationDuration: Double

    /// Default style
    public static let `default` = TabIndicatorStyle(
        height: 0,
        color: .clear,
        horizontalInset: 0,
        cornerRadius: 0,
        animationDuration: 0.3
    )

    /// Custom initializer with default values
    public init(
        height: CGFloat? = nil,
        color: Color? = nil,
        horizontalInset: CGFloat? = nil,
        cornerRadius: CGFloat? = nil,
        animationDuration: Double? = nil
    ) {
        self.height = height ?? Self.default.height
        self.color = color ?? Self.default.color
        self.horizontalInset = horizontalInset ?? Self.default.horizontalInset
        self.cornerRadius = cornerRadius ?? Self.default.cornerRadius
        self.animationDuration = animationDuration ?? Self.default.animationDuration
    }
}
