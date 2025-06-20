import SwiftUI

// Wrapper for tabbed content that supports swipe and index binding
struct TabContent<Content: View>: View {

    @Binding var selectedIndex: Int
    let tabCount: Int
    @Binding var isSwipeEnabled: Bool
    let content: (Int) -> Content

    init(
        selectedIndex: Binding<Int>,
        tabCount: Int,
        isSwipeEnabled: Binding<Bool> = .constant(true),
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self._selectedIndex = selectedIndex
        self.tabCount = tabCount
        self._isSwipeEnabled = isSwipeEnabled
        self.content = content
    }

    var body: some View {
        TabContentContainer(
            selectedIndex: $selectedIndex,
            tabCount: tabCount,
            isSwipeEnabled: isSwipeEnabled,
            content: content
        )
    }
}

