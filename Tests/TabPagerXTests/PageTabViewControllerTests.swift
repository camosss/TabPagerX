import XCTest
import SwiftUI
@testable import TabPagerX

private func makeController(
    ids: [AnyHashable],
    isSwipeEnabled: Bool = true
) -> PageTabViewController<Text> {
    PageTabViewController(
        content: { index in Text("\(index)") },
        itemIDs: ids,
        isSwipeEnabled: isSwipeEnabled
    )
}

// MARK: - PageView DataSource

final class PageTabDataSourceTests: XCTestCase {

    func test_dataSource_neighborsResolveFromGivenViewController() {
        let controller = makeController(ids: ["a", "b", "c"])
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
        let controller = makeController(ids: ["a", "b", "c"])
        guard let first = controller.viewControllers?.first,
              let second = controller.pageViewController(controller, viewControllerAfter: first) else {
            return XCTFail("failed to build pages")
        }

        let backward = controller.pageViewController(controller, viewControllerBefore: second)
        XCTAssertEqual(backward, first)
    }

    func test_dataSource_unknownViewController_returnsNil() {
        let controller = makeController(ids: ["a", "b", "c"])
        let stranger = UIViewController()

        XCTAssertNil(controller.pageViewController(controller, viewControllerAfter: stranger))
        XCTAssertNil(controller.pageViewController(controller, viewControllerBefore: stranger))
    }

    func test_dataSource_singleTab_hasNoNeighbors() {
        let controller = makeController(ids: ["only"])
        guard let first = controller.viewControllers?.first else {
            return XCTFail("initial view controller not set")
        }

        XCTAssertNil(controller.pageViewController(controller, viewControllerAfter: first))
        XCTAssertNil(controller.pageViewController(controller, viewControllerBefore: first))
    }
}

// MARK: - Swipe Toggle

final class SwipeToggleTests: XCTestCase {

    private func pageScrollView(of controller: UIViewController) -> UIScrollView? {
        controller.view.subviews.compactMap { $0 as? UIScrollView }.first
    }

    func test_updateSwipeEnabled_togglesScrollViewAtRuntime() {
        let controller = makeController(ids: ["a", "b", "c"])
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
        let controller = makeController(ids: ["a", "b", "c"], isSwipeEnabled: false)
        controller.loadViewIfNeeded()

        XCTAssertEqual(pageScrollView(of: controller)?.isScrollEnabled, false)
    }
}

// MARK: - Item ID Based Cache

final class ItemIDCacheTests: XCTestCase {

    private func testContent(_ index: Int) -> Text {
        Text("\(index)")
    }

    func test_appendItems_keepsCachedPagesForSurvivingIDs() {
        let controller = makeController(ids: ["a", "b", "c"])
        guard let first = controller.viewControllers?.first,
              let second = controller.pageViewController(controller, viewControllerAfter: first) else {
            return XCTFail("failed to build pages")
        }

        controller.updateTabData(itemIDs: ["a", "b", "c", "d"], content: testContent)

        // Same instance must be returned for the surviving id — state preserved
        let secondAfterAppend = controller.pageViewController(controller, viewControllerAfter: first)
        XCTAssertEqual(second, secondAfterAppend)
        XCTAssertEqual(controller.tabCount, 4)
    }

    func test_replaceItems_dropsCacheForRemovedIDs() {
        let controller = makeController(ids: ["a", "b", "c"])
        guard let first = controller.viewControllers?.first else {
            return XCTFail("initial view controller not set")
        }

        controller.updateTabData(itemIDs: ["x", "y", "z"], content: testContent)

        // Displayed page must be rebuilt — old item's state must not leak into the new item
        XCTAssertNotEqual(controller.viewControllers?.first, first)
        XCTAssertEqual(controller.selectedIndex, 0)
    }

    func test_reorderItems_cacheFollowsID() {
        let controller = makeController(ids: ["a", "b"])
        guard let pageA = controller.viewControllers?.first,
              let pageB = controller.pageViewController(controller, viewControllerAfter: pageA) else {
            return XCTFail("failed to build pages")
        }

        controller.updateTabData(itemIDs: ["b", "a"], content: testContent)

        // Index 0 now holds item b — its cached page must move with the id
        XCTAssertEqual(controller.viewControllers?.first, pageB)
    }

    func test_shrinkItems_clampsSelectedIndex() {
        let controller = makeController(ids: ["a", "b", "c"], isSwipeEnabled: false)
        controller.updateIndex(to: 2)
        XCTAssertEqual(controller.selectedIndex, 2)

        controller.updateTabData(itemIDs: ["a"], content: testContent)

        XCTAssertEqual(controller.selectedIndex, 0)
        XCTAssertEqual(controller.tabCount, 1)
    }

    func test_emptyItems_resetsSelectedIndex() {
        let controller = makeController(ids: ["a", "b"])

        controller.updateTabData(itemIDs: [], content: testContent)

        XCTAssertEqual(controller.selectedIndex, 0)
        XCTAssertEqual(controller.tabCount, 0)
    }

    func test_sameItems_keepsDisplayedPage() {
        let controller = makeController(ids: ["a", "b", "c"])
        guard let first = controller.viewControllers?.first else {
            return XCTFail("initial view controller not set")
        }

        controller.updateTabData(itemIDs: ["a", "b", "c"], content: testContent)

        XCTAssertEqual(controller.viewControllers?.first, first)
    }
}
