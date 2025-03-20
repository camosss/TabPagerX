import SwiftUI

// Individual tab button view
struct TabButton: View {

    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .center) // Visualize selected state
            .background(isSelected ? Color.blue : Color.clear)
            .contentShape(Rectangle()) // Expand tap area
    }
}
