import SwiftUI

struct TabContent<Content: View>: View {

    /// Selected index
    @Binding fileprivate var selectedIndex: Int

    /// Content closure
    fileprivate let content: (Int) -> Content

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                // Temporary scope, actually uses tabs.count
                ForEach(0..<10, id: \.self) { index in
                    content(index)
                        .frame(width: UIScreen.main.bounds.width)
                }
            }
            .offset(x: -CGFloat(selectedIndex) * UIScreen.main.bounds.width)
        }
        .animation(.easeInOut, value: selectedIndex)
    }
}
