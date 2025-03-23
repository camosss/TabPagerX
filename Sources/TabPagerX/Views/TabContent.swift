import SwiftUI

struct TabContent<Content: View>: View {

    @Binding var selectedIndex: Int

    let tabCount: Int
    let content: (Int) -> Content

    /// drag offset for swipe gesture
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in

                    // Create tab content
                    HStack(spacing: 0) {
                        ForEach(0..<tabCount, id: \.self) { index in
                            content(index)
                                .frame(width: geometry.size.width)
                                .id(index)
                        }
                    }
                    .offset(x: dragOffset) // Real-time position adjustment during swipe
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Reflect drag distance during the drag
                                dragOffset = value.translation.width
                            }
                            .onEnded { gesture in
                                let pageWidth = geometry.size.width
                                let dragDistance = gesture.translation.width

                                /// Page transition threshold
                                let threshold = pageWidth / 2
                                let newIndex = calculateNewIndex(
                                    dragDistance: dragDistance,
                                    threshold: threshold
                                )

                                withAnimation(.easeInOut) {
                                    selectedIndex = newIndex

                                    // Reset offset after drag ends
                                    dragOffset = 0
                                }
                            }
                    )
                    .onChange(of: selectedIndex) { newIndex in
                        withAnimation(.easeInOut) {
                            // Scroll to the selected page
                            proxy.scrollTo(newIndex, anchor: .leading)

                            // Reset offset when index changes
                            dragOffset = 0
                        }
                    }
                }
            }
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
