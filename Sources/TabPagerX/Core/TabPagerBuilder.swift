import SwiftUI

@resultBuilder
public enum TabPagerBuilder {
    public static func buildBlock(_ components: TabPagerItem...) -> [TabPagerItem] {
        return components
    }
}
