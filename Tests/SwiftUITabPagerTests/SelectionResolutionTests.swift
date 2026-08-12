import XCTest
@testable import SwiftUITabPager

/// Rules that keep the binding, the tab bar and the visible page pointing at the
/// same tab. A regression here shows up as "the app says tab X, the screen shows
/// tab Y", so each rule gets its own case.
final class SelectionResolutionTests: XCTestCase {

    private struct Item: Identifiable, Equatable {
        let id: String
    }

    private let items = [Item(id: "home"), Item(id: "search"), Item(id: "profile")]

    // MARK: resolved(current:in:)

    func test_emptyItems_keepsPresetID() {
        // A deep-linked id must survive until the fetch comes back
        let resolved = TabPagerSelection.resolved(current: "profile", in: [Item]())
        XCTAssertEqual(resolved, "profile")
    }

    func test_emptyItems_andNoSelection_staysNil() {
        let resolved = TabPagerSelection.resolved(current: nil, in: [Item]())
        XCTAssertNil(resolved)
    }

    func test_noSelection_selectsFirstItem() {
        XCTAssertEqual(TabPagerSelection.resolved(current: nil, in: items), "home")
    }

    func test_validSelection_isLeftAlone() {
        XCTAssertEqual(TabPagerSelection.resolved(current: "profile", in: items), "profile")
    }

    func test_unknownID_fallsBackToFirstItem() {
        XCTAssertEqual(TabPagerSelection.resolved(current: "does-not-exist", in: items), "home")
    }

    /// Regression: removing the selected tab used to leave the binding holding the
    /// removed id while the pager displayed the first tab
    func test_removingSelectedItem_movesSelectionOffTheRemovedID() {
        let remaining = items.filter { $0.id != "profile" }
        XCTAssertEqual(TabPagerSelection.resolved(current: "profile", in: remaining), "home")
    }

    func test_reordering_keepsTheSameItemSelected() {
        XCTAssertEqual(TabPagerSelection.resolved(current: "search", in: items.reversed()), "search")
    }

    func test_appending_keepsTheSameItemSelected() {
        let grown = items + [Item(id: "new")]
        XCTAssertEqual(TabPagerSelection.resolved(current: "search", in: grown), "search")
    }

    // MARK: index(of:in:)

    func test_index_findsTheSelectedItem() {
        XCTAssertEqual(TabPagerSelection.index(of: "profile", in: items), 2)
    }

    func test_index_followsTheItemAfterReorder() {
        XCTAssertEqual(TabPagerSelection.index(of: "profile", in: items.reversed()), 0)
    }

    func test_index_ofUnknownID_isZero() {
        XCTAssertEqual(TabPagerSelection.index(of: "nope", in: items), 0)
    }

    func test_index_ofNil_isZero() {
        XCTAssertEqual(TabPagerSelection.index(of: nil, in: items), 0)
    }

    func test_index_inEmptyItems_isZero() {
        XCTAssertEqual(TabPagerSelection.index(of: "home", in: [Item]()), 0)
    }
}
