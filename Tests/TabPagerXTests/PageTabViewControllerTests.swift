import XCTest
import SwiftUI
@testable import TabPagerX

// MARK: - PageView DataSource

final class PageTabDataSourceTests: XCTestCase {

    private func makeController(tabCount: Int) -> PageTabViewController<Text> {
        PageTabViewController(
            content: { index in Text("\(index)") },
            tabCount: tabCount,
            isSwipeEnabled: true
        )
    }

    func test_dataSource_neighborsResolveFromGivenViewController() {
        let controller = makeController(tabCount: 3)
        guard let first = controller.viewControllers?.first else {
            return XCTFail("initial view controller not set")
        }

        guard let second = controller.pageViewController(controller, viewControllerAfter: first) else {
            return XCTFail("expected neighbor after first page")
        }

        // selectedIndex is still 0 (stale) — neighbor must resolve from the passed VC, not selectedIndex
        guard let third = controller.pageViewController(controller, viewControllerAfter: second) else {
            return XCTFail("expected neighbor after second page")
        }
        XCTAssertNotEqual(second, third)

        XCTAssertNil(controller.pageViewController(controller, viewControllerAfter: third))
        XCTAssertNil(controller.pageViewController(controller, viewControllerBefore: first))
    }

    func test_dataSource_backwardNeighborResolvesFromGivenViewController() {
        let controller = makeController(tabCount: 3)
        guard let first = controller.viewControllers?.first,
              let second = controller.pageViewController(controller, viewControllerAfter: first) else {
            return XCTFail("failed to build pages")
        }

        let backward = controller.pageViewController(controller, viewControllerBefore: second)
        XCTAssertEqual(backward, first)
    }

    func test_dataSource_unknownViewController_returnsNil() {
        let controller = makeController(tabCount: 3)
        let stranger = UIViewController()

        XCTAssertNil(controller.pageViewController(controller, viewControllerAfter: stranger))
        XCTAssertNil(controller.pageViewController(controller, viewControllerBefore: stranger))
    }

    func test_dataSource_singleTab_hasNoNeighbors() {
        let controller = makeController(tabCount: 1)
        guard let first = controller.viewControllers?.first else {
            return XCTFail("initial view controller not set")
        }

        XCTAssertNil(controller.pageViewController(controller, viewControllerAfter: first))
        XCTAssertNil(controller.pageViewController(controller, viewControllerBefore: first))
    }
}

// MARK: - Swipe Toggle

final class SwipeToggleTests: XCTestCase {

    private func makeController(isSwipeEnabled: Bool) -> PageTabViewController<Text> {
        PageTabViewController(
            content: { index in Text("\(index)") },
            tabCount: 3,
            isSwipeEnabled: isSwipeEnabled
        )
    }

    private func pageScrollView(of controller: UIViewController) -> UIScrollView? {
        controller.view.subviews.compactMap { $0 as? UIScrollView }.first
    }

    func test_updateSwipeEnabled_togglesScrollViewAtRuntime() {
        let controller = makeController(isSwipeEnabled: true)
        controller.loadViewIfNeeded()

        XCTAssertEqual(pageScrollView(of: controller)?.isScrollEnabled, true)

        controller.updateSwipeEnabled(false)
        XCTAssertEqual(controller.isSwipeEnabled, false)
        XCTAssertEqual(pageScrollView(of: controller)?.isScrollEnabled, false)

        controller.updateSwipeEnabled(true)
        XCTAssertEqual(controller.isSwipeEnabled, true)
        XCTAssertEqual(pageScrollView(of: controller)?.isScrollEnabled, true)
    }

    func test_initWithSwipeDisabled_scrollViewDisabled() {
        let controller = makeController(isSwipeEnabled: false)
        controller.loadViewIfNeeded()

        XCTAssertEqual(pageScrollView(of: controller)?.isScrollEnabled, false)
    }
}
