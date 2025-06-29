import SwiftUI

/// Individual tab button view
struct TabButton: View {

    let title: String
    let isSelected: Bool

    let buttonStyle: TabButtonStyle

    var body: some View {
        Text(title)
            .font(isSelected ? buttonStyle.selected.font : buttonStyle.normal.font)
            .foregroundColor(isSelected ? buttonStyle.selected.textColor : buttonStyle.normal.textColor)
            .padding(buttonStyle.padding)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(isSelected ? buttonStyle.selected.backgroundColor : buttonStyle.normal.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: buttonStyle.cornerRadius)
                    .stroke(
                        isSelected ? (buttonStyle.selected.borderColor ?? .clear) : (buttonStyle.normal.borderColor ?? .clear),
                        lineWidth: (isSelected ? buttonStyle.selected.borderWidth : buttonStyle.normal.borderWidth) ?? 0
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: buttonStyle.cornerRadius))
            .contentShape(Rectangle())
    }
}
