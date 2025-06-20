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

// Bridges SwiftUI view with UIKit-based page controller
private struct TabContentContainer<Content: View>: UIViewControllerRepresentable {

    @Binding var selectedIndex: Int

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
        return controller
    }

    func updateUIViewController(
        _ uiViewController: PageTabViewController<Content>,
        context: Context
    ) {
        uiViewController.updateIndex(to: selectedIndex)
    }
}

private class PageTabViewController<Content: View>: UIPageViewController,
                                                    UIPageViewControllerDataSource,
                                                    UIPageViewControllerDelegate {

    // Caches each tab's content to preserve state
    private var viewControllersCache: [Int: UIHostingController<Content>] = [:]

    private let content: (Int) -> Content
    private let tabCount: Int

    var selectedIndex: Int = 0

    // Callback to notify parent of selected index change
    var onIndexChanged: ((Int) -> Void)?

    init(
        content: @escaping (Int) -> Content,
        tabCount: Int,
        isSwipeEnabled: Bool
    ) {
        self.content = content
        self.tabCount = tabCount

        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )

        self.dataSource = self
        self.delegate = self

        let initialVC = getViewController(at: selectedIndex)
        setViewControllers([initialVC], direction: .forward, animated: false)

        if !isSwipeEnabled {
            view.subviews
                .compactMap { $0 as? UIScrollView }
                .forEach { $0.isScrollEnabled = false }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Lazily loads and caches tab content
    private func getViewController(at index: Int) -> UIHostingController<Content> {
        if let cached = viewControllersCache[index] {
            return cached

        } else {
            let vc = UIHostingController(rootView: content(index))
            viewControllersCache[index] = vc
            return vc
        }
    }

    // Handles programmatic page transitions
    func updateIndex(to newIndex: Int) {
        guard newIndex != selectedIndex,
              newIndex >= 0,
              newIndex < tabCount
        else { return }

        let direction: NavigationDirection = (newIndex > selectedIndex) ? .forward : .reverse
        let nextVC = getViewController(at: newIndex)

        setViewControllers(
            [nextVC],
            direction: direction,
            animated: true
        )
        selectedIndex = newIndex
    }

    // MARK: - PageView DataSource
    func pageViewController(
        _: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {

        guard selectedIndex > 0 else { return nil }
        return getViewController(at: selectedIndex - 1)
    }

    func pageViewController(
        _: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {

        guard selectedIndex < tabCount - 1 else { return nil }
        return getViewController(at: selectedIndex + 1)
    }

    // MARK: - PageView Delegate
    // Syncs index when user swipes
    func pageViewController(
        _: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {

        if completed,
           let current = viewControllers?.first,
           let index = viewControllersCache.first(where: { $0.value == current })?.key {

            selectedIndex = index
            onIndexChanged?(index)
        }
    }
}
