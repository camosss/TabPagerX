import SwiftUI

struct TabContent<Content: View>: View {

    @Binding var selectedIndex: Int

    let tabCount: Int
    let content: (Int) -> Content

    /// drag offset for swipe gesture
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            createTabScrollView(geometry: geometry)
                .ignoresSafeArea(edges: .bottom)
        }
    }

    /// Create the scroll view for tab content
    private func createTabScrollView(geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                createTabContent(geometry: geometry)
                    .offset(x: dragOffset)
                    .gesture(createDragGesture(geometry: geometry))
                    .onChange(of: selectedIndex) { newIndex in
                        handleIndexChange(newIndex: newIndex, proxy: proxy)
                    }
            }
        }
    }

    /// Create the tab content with HStack
    private func createTabContent(geometry: GeometryProxy) -> some View {
        LazyHStack(spacing: 0) {
            ForEach(0..<tabCount, id: \.self) { index in
                ZStack {
                    content(index)

                    // Expand touch area"
                    Color.clear
                        .allowsHitTesting(false)
                }
                .frame(width: geometry.size.width)
                .id(index)
                .contentShape(Rectangle())
            }
        }
    }

    /// Create the drag gesture for swipe navigation
    private func createDragGesture(geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                // Reflect drag distance during the drag
                dragOffset = value.translation.width
            }
            .onEnded { gesture in
                handleDragEnded(
                    gesture: gesture,
                    pageWidth: geometry.size.width
                )
            }
    }

    /// Handle drag gesture onEnded event
    private func handleDragEnded(gesture: DragGesture.Value, pageWidth: CGFloat) {
        let dragDistance = gesture.translation.width
        let threshold = pageWidth / 2
        let newIndex = calculateNewIndex(
            dragDistance: dragDistance,
            threshold: threshold
        )

        withAnimation(.easeInOut) {
            selectedIndex = newIndex
            dragOffset = 0
        }
    }

    /// Handle selectedIndex change to scroll to the selected tab
    private func handleIndexChange(newIndex: Int, proxy: ScrollViewProxy) {
        withAnimation(.easeInOut) {
            proxy.scrollTo(newIndex, anchor: .leading)
            dragOffset = 0
        }
    }

    /// New index calculation logic
    private func calculateNewIndex(dragDistance: CGFloat, threshold: CGFloat) -> Int {
        var newIndex = selectedIndex

        if abs(dragDistance) > threshold {
            // Right swipe (previous page)
            if dragDistance > 0 {
                newIndex = max(0, selectedIndex - 1)

                // Left swipe (next page)
            } else {
                newIndex = min(tabCount - 1, selectedIndex + 1)
            }
        }
        return newIndex
    }
}
