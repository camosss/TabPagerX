import UIKit
import SwiftUI

class PageTabViewController<Content: View>: UIPageViewController,
                                                    UIPageViewControllerDataSource,
                                                    UIPageViewControllerDelegate {

    // Caches each tab's content to preserve state
    private var viewControllersCache: [Int: UIHostingController<Content>] = [:]

    private var content: (Int) -> Content
    private(set) var tabCount: Int

    var selectedIndex: Int = 0

    // Callback to notify parent of selected index change
    var onIndexChanged: ((Int) -> Void)?
    var onScrollProgressChanged: ((CGFloat) -> Void)?

    private var isProgrammaticTransition = false
    private var scrollViewObservation: NSKeyValueObservation?
    private(set) var isSwipeEnabled: Bool

    // Internal paging scroll view of UIPageViewController
    private var pageScrollView: UIScrollView? {
        view.subviews.compactMap { $0 as? UIScrollView }.first
    }

    init(
        content: @escaping (Int) -> Content,
        tabCount: Int,
        isSwipeEnabled: Bool
    ) {
        self.content = content
        self.tabCount = tabCount
        self.isSwipeEnabled = isSwipeEnabled

        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )

        self.dataSource = self
        self.delegate = self

        if tabCount > 0 {
            let initialVC = getViewController(at: selectedIndex)
            setViewControllers([initialVC], direction: .forward, animated: false)
        }

        if !isSwipeEnabled {
            pageScrollView?.isScrollEnabled = false
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollViewObservation()
    }

    // Allows toggling swipe at runtime via the contentSwipeEnabled modifier
    func updateSwipeEnabled(_ enabled: Bool) {
        guard enabled != isSwipeEnabled else { return }
        isSwipeEnabled = enabled
        pageScrollView?.isScrollEnabled = enabled
    }

    private func setupScrollViewObservation() {
        guard let scrollView = pageScrollView else { return }

        scrollViewObservation = scrollView.observe(\.contentOffset, options: [.new]) { [weak self] scrollView, _ in
            guard let self = self, !self.isProgrammaticTransition else { return }
            let width = scrollView.frame.width
            guard width > 0 else { return }
            let progress = (scrollView.contentOffset.x - width) / width
            let clamped = min(max(progress, -1), 1)
            self.onScrollProgressChanged?(clamped)
        }
    }

    // Reverse lookup of a cached view controller's index
    private func index(of viewController: UIViewController) -> Int? {
        viewControllersCache.first(where: { $0.value == viewController })?.key
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

    func updateTabData(tabCount: Int, content: @escaping (Int) -> Content) {
        let tabCountChanged = self.tabCount != tabCount
        self.content = content
        self.tabCount = tabCount

        if tabCountChanged {
            viewControllersCache.removeAll()

            guard tabCount > 0 else { return }

            let clamped = min(max(selectedIndex, 0), tabCount - 1)
            selectedIndex = clamped
            let vc = getViewController(at: clamped)
            setViewControllers([vc], direction: .forward, animated: false)
        } else {
            for (index, vc) in viewControllersCache {
                vc.rootView = content(index)
            }
        }
    }

    // Handles programmatic page transitions
    func updateIndex(to newIndex: Int) {
        guard newIndex != selectedIndex,
              newIndex >= 0,
              newIndex < tabCount
        else { return }

        isProgrammaticTransition = true

        // Deferred one tick — updateIndex runs inside updateUIViewController and
        // writing SwiftUI state synchronously during a view update is undefined behavior
        DispatchQueue.main.async { [weak self] in
            self?.onScrollProgressChanged?(0)
        }

        let direction: NavigationDirection = (newIndex > selectedIndex) ? .forward : .reverse
        let nextVC = getViewController(at: newIndex)

        setViewControllers(
            [nextVC],
            direction: direction,
            animated: isSwipeEnabled
        ) { [weak self] _ in
            self?.isProgrammaticTransition = false
        }
        selectedIndex = newIndex
    }

    // MARK: - PageView DataSource
    // Neighbors are resolved from the passed view controller, not selectedIndex —
    // during fast successive swipes the data source is asked before selectedIndex syncs
    func pageViewController(
        _: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {

        guard let index = index(of: viewController), index > 0 else { return nil }
        return getViewController(at: index - 1)
    }

    func pageViewController(
        _: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {

        guard let index = index(of: viewController), index < tabCount - 1 else { return nil }
        return getViewController(at: index + 1)
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
           let index = index(of: current) {

            selectedIndex = index
            onIndexChanged?(index)
            onScrollProgressChanged?(0)
        }
    }
}
