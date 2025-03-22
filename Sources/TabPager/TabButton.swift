import SwiftUI

/// Individual tab button view
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let style: TabButtonStyle

    var body: some View {
        ZStack(alignment: .bottom) {
            Text(title)
                .font(isSelected ? style.selected.font : style.normal.font)
                .foregroundColor(isSelected ? style.selected.textColor : style.normal.textColor)
                .padding(style.padding)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(isSelected ? style.selected.backgroundColor : style.normal.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(style.borderColor, lineWidth: style.borderWidth)
                )
                .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
                .contentShape(Rectangle())

            // Indicator
            if isSelected {
                RoundedRectangle(cornerRadius: style.indicatorStyle.cornerRadius)
                    .fill(style.indicatorStyle.color)
                    .frame(height: style.indicatorStyle.height)
                    .padding(.horizontal, style.indicatorStyle.horizontalInset)
            }
        }
    }
}
