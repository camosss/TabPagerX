import SwiftUI

public struct TabPager<Content: View>: View {

    /// List of tab titles
    @Binding var tabs: [String]

    /// Index of the selected tab
    @Binding var selectedIndex: Int

    /// an option for the initial index
    private let initialIndex: Int?

    /// Defines the layout style for the tab bar
    private var layoutStyle: TabLayoutStyle

    /// button style property
    private var buttonStyle: TabButtonStyle

    /// Content view for each tab
    private let content: (Int) -> Content

    /// Designed for the user to provide the tab list, selected index, and content
    public init(
        tabs: Binding<[String]>,
        selectedIndex: Binding<Int>,
        initialIndex: Int? = nil,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self._tabs = tabs
        self._selectedIndex = selectedIndex
        self.initialIndex = initialIndex
        self.content = content
        self.layoutStyle = .fixed
        self.buttonStyle = .default
    }

    public var body: some View {
        VStack(spacing: 0) {
            TabBar(
                tabs: $tabs,
                selectedIndex: $selectedIndex,
                layoutStyle: layoutStyle,
                buttonStyle: buttonStyle
            )
            TabContent(
                selectedIndex: $selectedIndex,
                tabCount: tabs.count,
                content: content
            )
        }
        .onAppear {
            if let initialIndex = initialIndex,
               initialIndex >= 0 && initialIndex < tabs.count {
                // Forcefully set the initial index when the view appears
                selectedIndex = initialIndex

            } else if selectedIndex < 0 || selectedIndex >= tabs.count {
                // Ensure the selected index remains within a valid range
                selectedIndex = 0
            }
        }
    }
}

public extension TabPager {
    /// Modifier to customize TabBar layout style
    func tabBarLayoutStyle(_ style: TabLayoutStyle) -> Self {
        var new = self
        new.layoutStyle = style
        return new
    }

    /// Modifier to customize TabButton style
    func tabButtonStyle(
        font: Font = .headline,
        textColor: Color = .black,
        selectedTextColor: Color = .black,
        backgroundColor: Color = .clear,
        selectedBackgroundColor: Color = .blue,
        padding: EdgeInsets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12),
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        cornerRadius: CGFloat = 0
    ) -> Self {
        var new = self
        new.buttonStyle = TabButtonStyle(
            font: font,
            textColor: textColor,
            selectedTextColor: selectedTextColor,
            backgroundColor: backgroundColor,
            selectedBackgroundColor: selectedBackgroundColor,
            padding: padding,
            borderColor: borderColor,
            borderWidth: borderWidth,
            cornerRadius: cornerRadius
        )
        return new
    }
}

struct ContentView: View {

    @State private var tabs = ["Tab 1", "Tab 2", "Tab 3"]
    @State private var selectedIndex = 0

    var body: some View {
        TabPager(
            tabs: $tabs,
            selectedIndex: $selectedIndex
        ) { index in
            Text("\(tabs[index])")
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
        }
        .tabBarLayoutStyle(.scrollable)
        .tabButtonStyle(
            font: .title2,
            textColor: .gray,
            selectedTextColor: .white,
            backgroundColor: .white,
            selectedBackgroundColor: .purple,
            padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16),
            borderColor: .gray,
            borderWidth: 1,
            cornerRadius: 8
        )
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
