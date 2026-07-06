import Foundation
import CoreGraphics

/// Selection state passed to each tab label builder
public struct TabState: Equatable, Sendable {

    /// Whether this tab is the visually highlighted one
    /// Follows the finger during swipe — flips once the swipe passes 50%
    public let isSelected: Bool

    /// 0 (unselected) to 1 (selected), interpolated in real time during swipe
    /// Use for continuous effects like color or scale interpolation
    public let selectionProgress: CGFloat

    public init(isSelected: Bool, selectionProgress: CGFloat) {
        self.isSelected = isSelected
        self.selectionProgress = selectionProgress
    }
}
