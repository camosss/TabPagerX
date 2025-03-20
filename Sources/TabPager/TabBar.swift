import SwiftUI

struct TabBar: View {

    @Binding var tabs: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        // Initialize spacing to 0, replace with dynamic adjustment
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { index in
                TabButton(
                    title: tabs[index],
                    isSelected: index == selectedIndex
                )
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selectedIndex = index
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
