import SwiftUI

@resultBuilder
public struct TabPagerBuilder {
    public static func buildBlock<Content: View>(
        _ components: TabPagerItem<Content>...
    ) -> [TabPagerItem<Content>] {
        components
    }
}
