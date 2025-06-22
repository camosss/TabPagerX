import SwiftUI

@resultBuilder
public enum TabPagerBuilder {

    /// Combines multiple TabPagerItem elements into a single array.
    /// Called when multiple expressions are listed in the builder block.
    public static func buildBlock(_ components: TabPagerItem...) -> [TabPagerItem] {
        return components
    }
}
