// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct TabPager<Content: View>: View {

    /// List of tab titles
    @Binding private var tabs: [String]

    /// Index of the selected tab
    @Binding private var selectedIndex: Int

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

        }
    }
}
