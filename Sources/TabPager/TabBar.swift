import SwiftUI

struct TabBar: View {

    /// List of tab titles
    @Binding fileprivate var tabs: [String]

    /// Selected index
    @Binding fileprivate var selectedIndex: Int

    var body: some View {
        HStack(spacing: 10) {
            ForEach(tabs.indices, id: \.self) { index in
                Text(tabs[index])
                    .font(.headline)
                    .padding(8)
                    .onTapGesture {
                        selectedIndex = index
                    }
            }
        }
        .padding(.horizontal)
    }
}
