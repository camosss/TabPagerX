import UIKit
import SwiftUI

// Bridges SwiftUI view with UIKit-based page controller
struct TabContentContainer<Content: View>: UIViewControllerRepresentable {

    @Binding var selectedIndex: Int
    @Binding var scrollProgress: CGFloat

    let tabCount: Int
    let isSwipeEnabled: Bool
    let content: (Int) -> Content

    func makeUIViewController(context: Context) -> PageTabViewController<Content> {
        let controller = PageTabViewController(
            content: content,
            tabCount: tabCount,
            isSwipeEnabled: isSwipeEnabled
        )
        controller.selectedIndex = selectedIndex
        controller.onIndexChanged = { newIndex in
            selectedIndex = newIndex
        }
        controller.onScrollProgressChanged = { progress in
            scrollProgress = progress
        }
        return controller
    }

    func updateUIViewController(
        _ uiViewController: PageTabViewController<Content>,
        context: Context
    ) {
        uiViewController.updateTabData(tabCount: tabCount, content: content)
        uiViewController.updateIndex(to: selectedIndex)
    }
}
