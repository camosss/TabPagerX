// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct TabPager<Content: View>: View {

    /// List of tab titles
    @Binding var tabs: [String]

    /// Index of the selected tab
    @Binding var selectedIndex: Int

    /// Content view for each tab
    private let content: (Int) -> Content

    /// Designed for the user to provide the tab list, selected index, and content
    public init(
        tabs: Binding<[String]>,
        selectedIndex: Binding<Int>,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self._tabs = tabs
        self._selectedIndex = selectedIndex
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            TabBar(tabs: $tabs, selectedIndex: $selectedIndex)
            TabContent(
                selectedIndex: $selectedIndex,
                tabCount: tabs.count,
                content: content
            )
        }
    }
}

struct ContentView: View {
    @State private var tabs = ["Tab 1", "Tab 2", "Tab 3"]
    @State private var selectedIndex = 0

    var body: some View {
        TabPager(tabs: $tabs, selectedIndex: $selectedIndex) { index in
            Text("\(tabs[index])")
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
