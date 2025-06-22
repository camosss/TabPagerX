import SwiftUI

@resultBuilder
public enum TabPagerBuilder {

    /// Combines multiple TabPagerItem elements into a single array.
    /// Called when multiple expressions are listed in the builder block.
    public static func buildBlock(_ components: TabPagerItem...) -> [TabPagerItem] {
        return components
    }

    /// Handles arrays of TabPagerItem, such as when using `ForEach` or `.map`.
    /// This enables dynamic generation of tab items inside the builder.
    public static func buildArray(_ components: [TabPagerItem]) -> [TabPagerItem] {
        components
    }
}
