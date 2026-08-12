import Foundation

/// Pure selection rules, kept out of the view so they can be tested directly.
enum TabPagerSelection {

    /// The id that should be selected for a given items array.
    ///
    /// - Returns: `current` while items are still empty (a preset id may become
    ///   valid once data arrives), `current` when it still exists, otherwise the
    ///   first item's id.
    static func resolved<Item: Identifiable>(current: Item.ID?, in items: [Item]) -> Item.ID? {
        guard let first = items.first else { return current }

        if let current, items.contains(where: { $0.id == current }) {
            return current
        }
        return first.id
    }

    /// Index of the selected id, or 0 when it cannot be found.
    /// Content and tab bar both read this, so an unknown id must not leave them
    /// pointing at different tabs.
    static func index<Item: Identifiable>(of id: Item.ID?, in items: [Item]) -> Int {
        guard let id, let index = items.firstIndex(where: { $0.id == id }) else { return 0 }
        return index
    }
}
