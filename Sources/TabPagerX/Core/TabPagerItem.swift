import SwiftUI

public struct TabPagerItem {
    let view: AnyView
    let title: String
    let titleBuilder: () -> AnyView

    public init<V: View>(view: V, title: String) {
        self.view = AnyView(view)
        self.title = title
        self.titleBuilder = { AnyView(Text(title)) }
    }

    public init<V: View, T: View>(view: V, @ViewBuilder titleView: @escaping () -> T) {
        self.view = AnyView(view)
        self.title = "" // 기존 호환성을 위해 빈 문자열로 설정
        self.titleBuilder = { AnyView(titleView()) }
    }
}
