import SwiftUI

struct TabContent<Content: View>: View {

    @Binding var selectedIndex: Int
    let tabCount: Int

    /// Content closure
    let content: (Int) -> Content

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(0..<tabCount, id: \.self) { index in
                    content(index)
                        .frame(width: UIScreen.main.bounds.width)
                }
            }
            .offset(x: -CGFloat(selectedIndex) * UIScreen.main.bounds.width)
        }
        .animation(.easeInOut, value: selectedIndex)
    }
}
