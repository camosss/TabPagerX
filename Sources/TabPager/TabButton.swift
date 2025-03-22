import SwiftUI

// Individual tab button view
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let style: TabButtonStyle

    var body: some View {
        Text(title)
            .font(style.font)
            .foregroundColor(isSelected ? style.selectedTextColor : style.textColor)
            .padding(style.padding)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(isSelected ? style.selectedBackgroundColor : style.backgroundColor)
            .contentShape(Rectangle())
    }
}
