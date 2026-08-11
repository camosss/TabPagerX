import SwiftUI

// Structure to hold TabBar layout configuration properties
public struct TabBarLayoutConfig: Sendable {

    /// Spacing between buttons
    public let buttonSpacing: CGFloat

    /// Padding on the left and right sides
    public let sidePadding: CGFloat

    /// Default configuration
    public static let `default` = TabBarLayoutConfig(
        buttonSpacing: 0,
        sidePadding: 0
    )
}
