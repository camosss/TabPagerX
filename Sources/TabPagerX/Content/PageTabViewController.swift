import UIKit
import SwiftUI

class PageTabViewController<Content: View>: UIPageViewController,
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
