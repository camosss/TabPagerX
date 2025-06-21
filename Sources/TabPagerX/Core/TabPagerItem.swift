import SwiftUI

public struct TabPagerItem<Content: View>: View {
    public let view: Content
    public let title: String

    public init(view: Content, title: String) {
        self.view = view
        self.title = title
    }

    public var body: some View {
        view
    }
}
