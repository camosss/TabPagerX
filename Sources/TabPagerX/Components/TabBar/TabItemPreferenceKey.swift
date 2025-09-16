import SwiftUI

/// A named coordinate space used for tracking tab button positions.
enum CoordinateSpaces {
    static let tabBar = "TabBarFrame"
}

/// A PreferenceKey used to collect the layout frames of tab buttons by index.
/// Enables indicator alignment by sharing geometry across views.
struct TabButtonPreferenceKey: PreferenceKey {

    /// Default value is an empty dictionary of index-to-frame mappings.
    static var defaultValue: [Int: CGRect] = [:]

    static func reduce(
        value: inout [Int: CGRect],
        nextValue: () -> [Int: CGRect]
    ) {
        // Merge new values into the existing dictionary, overwriting duplicates.
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
