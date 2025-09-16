import SwiftUI

public struct TabBarSeparatorStyle {
    let color: Color
    let height: CGFloat
    let horizontalPadding: CGFloat
    let isHidden: Bool

    public static let none = TabBarSeparatorStyle(
        color: .clear,
        height: 0,
        horizontalPadding: 0,
        isHidden: true
    )

    public init(
        color: Color = .gray.opacity(0.2),
        height: CGFloat = 1,
        horizontalPadding: CGFloat = 0,
        isHidden: Bool = false
    ) {
        self.color = color
        self.height = height
        self.horizontalPadding = horizontalPadding
        self.isHidden = isHidden
    }
}
