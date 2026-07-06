import UIKit
import SwiftUI

// Bridges SwiftUI view with UIKit-based page controller
struct TabContentContainer<Content: View>: UIViewControllerRepresentable {

    @Binding var selectedIndex: Int
    @Binding var scrollProgress: CGFloat

    let itemIDs: [AnyHashable]
    let isSwipeEnabled: Bool
    let content: (Int) -> Content

    // Relays UIKit callbacks to the latest SwiftUI bindings
    // Bindings are refreshed on every update so callbacks never write to stale ones
    final class Coordinator {
        var selectedIndex: Binding<Int>
        var scrollProgress: Binding<CGFloat>

        init(selectedIndex: Binding<Int>, scrollProgress: Binding<CGFloat>) {
            self.selectedIndex = selectedIndex
            self.scrollProgress = scrollProgress
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedIndex: $selectedIndex, scrollProgress: $scrollProgress)
    }

    func makeUIViewController(context: Context) -> PageTabViewController<Content> {
        let controller = PageTabViewController(
            content: content,
            itemIDs: itemIDs,
            isSwipeEnabled: isSwipeEnabled
        )
        controller.selectedIndex = selectedIndex

        let coordinator = context.coordinator
        controller.onIndexChanged = { [weak coordinator] newIndex in
            coordinator?.selectedIndex.wrappedValue = newIndex
        }
        controller.onScrollProgressChanged = { [weak coordinator] progress in
            coordinator?.scrollProgress.wrappedValue = progress
        }
        return controller
    }

    func updateUIViewController(
        _ uiViewController: PageTabViewController<Content>,
        context: Context
    ) {
        context.coordinator.selectedIndex = $selectedIndex
        context.coordinator.scrollProgress = $scrollProgress

        uiViewController.updateSwipeEnabled(isSwipeEnabled)
        uiViewController.updateTabData(itemIDs: itemIDs, content: content)
        uiViewController.updateIndex(to: selectedIndex)
    }
}
