import SwiftUI

struct TabContent<Content: View>: View {

    @Binding var selectedIndex: Int

    let tabCount: Int
    let content: (Int) -> Content

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(0..<tabCount, id: \.self) { index in
                content(index)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(edges: .bottom)
        .animation(.easeInOut, value: selectedIndex)
    }
}
