import SwiftUI

struct TabContent<Content: View>: View {

    @Binding var selectedIndex: Int
    let tabCount: Int

    /// Content closure
    let content: (Int) -> Content

    init(
        selectedIndex: Binding<Int>,
        tabCount: Int,
        content: @escaping (Int) -> Content
    ) {
        self._selectedIndex = selectedIndex
        self.tabCount = tabCount
        self.content = content
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                LazyHStack(spacing: 0) {
                    ForEach(0..<tabCount, id: \.self) { index in
                        content(index)
                            .frame(width: UIScreen.main.bounds.width)
                            .id(index)
                    }
                }
                .onChange(of: selectedIndex) { newIndex in
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(newIndex, anchor: .leading)
                    }
                }
            }
        }
    }
}
