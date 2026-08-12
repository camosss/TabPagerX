import XCTest
@testable import SwiftUITabPager

/// Fixed tab bar sizing. Getting this wrong pushes the last tab off screen, which
/// only shows up on a narrow device or at an accessibility text size.
final class TabBarLayoutTests: XCTestCase {

    // MARK: cellWidth

    func test_cellWidth_splitsTheBarEvenly() {
        let width = TabBarLayout.cellWidth(barWidth: 400, tabCount: 4, buttonSpacing: 0, sidePadding: 0)
        XCTAssertEqual(width, 100)
    }

    func test_cellWidth_subtractsSpacingBetweenTabs() {
        // 3 tabs, 2 gaps of 10
        let width = TabBarLayout.cellWidth(barWidth: 320, tabCount: 3, buttonSpacing: 10, sidePadding: 0)
        XCTAssertEqual(width, 100)
    }

    func test_cellWidth_subtractsSidePaddingFromBothEdges() {
        let width = TabBarLayout.cellWidth(barWidth: 420, tabCount: 4, buttonSpacing: 0, sidePadding: 10)
        XCTAssertEqual(width, 100)
    }

    func test_cellWidth_singleTabTakesTheWholeBar() {
        let width = TabBarLayout.cellWidth(barWidth: 400, tabCount: 1, buttonSpacing: 12, sidePadding: 0)
        XCTAssertEqual(width, 400)
    }

    func test_cellWidth_beforeMeasurement_isNil() {
        XCTAssertNil(TabBarLayout.cellWidth(barWidth: 0, tabCount: 4, buttonSpacing: 0, sidePadding: 0))
    }

    func test_cellWidth_withoutTabs_isNil() {
        XCTAssertNil(TabBarLayout.cellWidth(barWidth: 400, tabCount: 0, buttonSpacing: 0, sidePadding: 0))
    }

    func test_cellWidth_whenPaddingEatsTheBar_isNil() {
        // Falls back to self-sizing labels rather than producing a negative width
        XCTAssertNil(TabBarLayout.cellWidth(barWidth: 100, tabCount: 4, buttonSpacing: 0, sidePadding: 60))
    }

    func test_cellWidth_whenSpacingEatsTheBar_isNil() {
        XCTAssertNil(TabBarLayout.cellWidth(barWidth: 100, tabCount: 6, buttonSpacing: 30, sidePadding: 0))
    }

    // MARK: isOverflowing

    func test_isOverflowing_whenLabelIsWiderThanItsTab() {
        XCTAssertTrue(TabBarLayout.isOverflowing(naturalLabelWidth: 140, cellWidth: 100))
    }

    func test_isOverflowing_whenLabelFits() {
        XCTAssertFalse(TabBarLayout.isOverflowing(naturalLabelWidth: 80, cellWidth: 100))
    }

    func test_isOverflowing_ignoresSubPointRounding() {
        XCTAssertFalse(TabBarLayout.isOverflowing(naturalLabelWidth: 100.3, cellWidth: 100))
    }

    func test_isOverflowing_beforeMeasurement_isFalse() {
        XCTAssertFalse(TabBarLayout.isOverflowing(naturalLabelWidth: 140, cellWidth: nil))
    }
}
