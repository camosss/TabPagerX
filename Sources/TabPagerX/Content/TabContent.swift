import SwiftUI

// Wrapper for tabbed content that supports swipe and index binding
struct TabContent<Content: View>: View {

    @Binding var selectedIndex: Int
    @Binding var scrollProgress: CGFloat
    let tabCount: Int
    @Binding var isSwipeEnabled: Bool
    let content: (Int) -> Content

    init(
        selectedIndex: Binding<Int>,
        scrollProgress: Binding<CGFloat>,
        tabCount: Int,
        isSwipeEnabled: Binding<Bool> = .constant(true),
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self._selectedIndex = selectedIndex
        self._scrollProgress = scrollProgress
        self.tabCount = tabCount
        self._isSwipeEnabled = isSwipeEnabled
        self.content = content
    }

    var body: some View {
        TabContentContainer(
            selectedIndex: $selectedIndex,
            scrollProgress: $scrollProgress,
            tabCount: tabCount,
            isSwipeEnabled: isSwipeEnabled,
            content: content
        )
    }
}
