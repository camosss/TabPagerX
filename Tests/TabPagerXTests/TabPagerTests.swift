import XCTest
@testable import TabPagerX

// MARK: - Index Clamping

final class IndexClampingTests: XCTestCase {

    func test_clamp_indexOverCount_returnsLastIndex() {
        let result = TabPagerHelper.clampIndex(5, itemCount: 3)
        XCTAssertEqual(result, 2)
    }

    func test_clamp_negativeIndex_returnsZero() {
        let result = TabPagerHelper.clampIndex(-1, itemCount: 3)
        XCTAssertEqual(result, 0)
    }

    func test_clamp_emptyItems_returnsZero() {
        let result = TabPagerHelper.clampIndex(3, itemCount: 0)
        XCTAssertEqual(result, 0)
    }

    func test_clamp_validIndex_returnsUnchanged() {
        let result = TabPagerHelper.clampIndex(1, itemCount: 3)
        XCTAssertEqual(result, 1)
    }

    func test_clamp_zeroIndex_returnsZero() {
        let result = TabPagerHelper.clampIndex(0, itemCount: 3)
        XCTAssertEqual(result, 0)
    }

    func test_clamp_lastIndex_returnsLastIndex() {
        let result = TabPagerHelper.clampIndex(2, itemCount: 3)
        XCTAssertEqual(result, 2)
    }

    func test_clamp_itemsShrink_clampsToNewLast() {
        // items: 5 → 3, selectedIndex was 4
        let result = TabPagerHelper.clampIndex(4, itemCount: 3)
        XCTAssertEqual(result, 2)
    }
}

// MARK: - Display Index

final class DisplayIndexTests: XCTestCase {

    func test_display_noScroll_returnsCurrent() {
        let result = TabPagerHelper.displayIndex(selectedIndex: 1, scrollProgress: 0, itemCount: 5)
        XCTAssertEqual(result, 1)
    }

    func test_display_scrollForwardPast50_returnsNext() {
        let result = TabPagerHelper.displayIndex(selectedIndex: 1, scrollProgress: 0.6, itemCount: 5)
        XCTAssertEqual(result, 2)
    }

    func test_display_scrollBackwardPast50_returnsPrevious() {
        let result = TabPagerHelper.displayIndex(selectedIndex: 2, scrollProgress: -0.6, itemCount: 5)
        XCTAssertEqual(result, 1)
    }

    func test_display_scrollForwardUnder50_returnsCurrent() {
        let result = TabPagerHelper.displayIndex(selectedIndex: 1, scrollProgress: 0.3, itemCount: 5)
        XCTAssertEqual(result, 1)
    }

    func test_display_scrollBackwardUnder50_returnsCurrent() {
        let result = TabPagerHelper.displayIndex(selectedIndex: 1, scrollProgress: -0.3, itemCount: 5)
        XCTAssertEqual(result, 1)
    }

    func test_display_scrollExactly50_returnsCurrent() {
        let result = TabPagerHelper.displayIndex(selectedIndex: 1, scrollProgress: 0.5, itemCount: 5)
        XCTAssertEqual(result, 1)
    }

    func test_display_firstTab_scrollBackward_staysAtZero() {
        let result = TabPagerHelper.displayIndex(selectedIndex: 0, scrollProgress: -0.8, itemCount: 5)
        XCTAssertEqual(result, 0)
    }

    func test_display_lastTab_scrollForward_staysAtLast() {
        let result = TabPagerHelper.displayIndex(selectedIndex: 4, scrollProgress: 0.8, itemCount: 5)
        XCTAssertEqual(result, 4)
    }

    func test_display_singleItem_scrollForward_staysAtZero() {
        let result = TabPagerHelper.displayIndex(selectedIndex: 0, scrollProgress: 0.8, itemCount: 1)
        XCTAssertEqual(result, 0)
    }

    func test_display_singleItem_scrollBackward_staysAtZero() {
        let result = TabPagerHelper.displayIndex(selectedIndex: 0, scrollProgress: -0.8, itemCount: 1)
        XCTAssertEqual(result, 0)
    }

    func test_display_emptyItems_returnsZero() {
        let result = TabPagerHelper.displayIndex(selectedIndex: 3, scrollProgress: 0.8, itemCount: 0)
        XCTAssertEqual(result, 0)
    }

    func test_display_invalidSelectedIndex_clampsFirst() {
        let result = TabPagerHelper.displayIndex(selectedIndex: 10, scrollProgress: 0, itemCount: 3)
        XCTAssertEqual(result, 2)
    }

    func test_display_negativeSelectedIndex_clampsToZero() {
        let result = TabPagerHelper.displayIndex(selectedIndex: -1, scrollProgress: 0.8, itemCount: 5)
        XCTAssertEqual(result, 1)
    }
}

// MARK: - Selection Progress

final class SelectionProgressTests: XCTestCase {

    func test_selectedTab_noScroll_isFull() {
        let result = TabPagerHelper.selectionProgress(for: 1, selectedIndex: 1, scrollProgress: 0)
        XCTAssertEqual(result, 1)
    }

    func test_selectedTab_scrollForward_decreases() {
        let result = TabPagerHelper.selectionProgress(for: 1, selectedIndex: 1, scrollProgress: 0.3)
        XCTAssertEqual(result, 0.7, accuracy: 0.0001)
    }

    func test_nextTab_scrollForward_increases() {
        let result = TabPagerHelper.selectionProgress(for: 2, selectedIndex: 1, scrollProgress: 0.3)
        XCTAssertEqual(result, 0.3, accuracy: 0.0001)
    }

    func test_previousTab_scrollBackward_increases() {
        let result = TabPagerHelper.selectionProgress(for: 0, selectedIndex: 1, scrollProgress: -0.4)
        XCTAssertEqual(result, 0.4, accuracy: 0.0001)
    }

    func test_unrelatedTab_isZero() {
        let result = TabPagerHelper.selectionProgress(for: 3, selectedIndex: 1, scrollProgress: 0.3)
        XCTAssertEqual(result, 0)
    }

    func test_wrongDirectionNeighbor_isZero() {
        let result = TabPagerHelper.selectionProgress(for: 0, selectedIndex: 1, scrollProgress: 0.3)
        XCTAssertEqual(result, 0)
    }

    func test_overscroll_isClampedToOne() {
        let next = TabPagerHelper.selectionProgress(for: 2, selectedIndex: 1, scrollProgress: 1.5)
        XCTAssertEqual(next, 1)

        let current = TabPagerHelper.selectionProgress(for: 1, selectedIndex: 1, scrollProgress: 1.5)
        XCTAssertEqual(current, 0)
    }
}

// MARK: - Style Defaults

final class StyleDefaultsTests: XCTestCase {

    // MARK: TabIndicatorStyle

    func test_indicatorStyle_default_heightIsZero() {
        let style = TabIndicatorStyle.default
        XCTAssertEqual(style.height, 0)
    }

    func test_indicatorStyle_default_colorIsClear() {
        XCTAssertEqual(TabIndicatorStyle.default.color, .clear)
    }

    func test_indicatorStyle_default_animationDuration() {
        XCTAssertEqual(TabIndicatorStyle.default.animationDuration, 0.3)
    }

    func test_indicatorStyle_custom_overridesDefaults() {
        let style = TabIndicatorStyle(height: 4, color: .blue, horizontalInset: 8, cornerRadius: 2, animationDuration: 0.5)
        XCTAssertEqual(style.height, 4)
        XCTAssertEqual(style.color, .blue)
        XCTAssertEqual(style.horizontalInset, 8)
        XCTAssertEqual(style.cornerRadius, 2)
        XCTAssertEqual(style.animationDuration, 0.5)
    }

    func test_indicatorStyle_partialCustom_usesDefaultsForNil() {
        let style = TabIndicatorStyle(height: 3, color: .red)
        XCTAssertEqual(style.height, 3)
        XCTAssertEqual(style.color, .red)
        XCTAssertEqual(style.horizontalInset, 0)
        XCTAssertEqual(style.cornerRadius, 0)
        XCTAssertEqual(style.animationDuration, 0.3)
    }

    // MARK: TabBarLayoutConfig

    func test_layoutConfig_default_allZero() {
        let config = TabBarLayoutConfig.default
        XCTAssertEqual(config.buttonSpacing, 0)
        XCTAssertEqual(config.sidePadding, 0)
    }

    func test_layoutConfig_custom() {
        let config = TabBarLayoutConfig(buttonSpacing: 8, sidePadding: 12)
        XCTAssertEqual(config.buttonSpacing, 8)
        XCTAssertEqual(config.sidePadding, 12)
    }

    // MARK: TabBarSeparatorStyle

    func test_separatorStyle_none_isHidden() {
        let style = TabBarSeparatorStyle.none
        XCTAssertTrue(style.isHidden)
        XCTAssertEqual(style.height, 0)
    }

    func test_separatorStyle_custom_isVisible() {
        let style = TabBarSeparatorStyle(color: .gray, height: 1)
        XCTAssertFalse(style.isHidden)
        XCTAssertEqual(style.height, 1)
    }

    func test_separatorStyle_defaultValues() {
        let style = TabBarSeparatorStyle()
        XCTAssertFalse(style.isHidden)
        XCTAssertEqual(style.height, 1)
        XCTAssertEqual(style.horizontalPadding, 0)
    }

    // MARK: TabLayoutStyle

    func test_layoutStyle_cases() {
        let fixed = TabLayoutStyle.fixed
        let scrollable = TabLayoutStyle.scrollable
        XCTAssertNotEqual(String(describing: fixed), String(describing: scrollable))
    }
}
