import SwiftUI

public struct TabPagerX: View {

    /// Index of the selected tab
    @Binding var selectedIndex: Int

    /// an option for the initial index
    private let initialIndex: Int?

    /// Internal storage of tab titles
    private let titles: [String]

    /// Internal storage of tab views
    private let views: [AnyView]

    /// Callback when tab changes
    private var onTabChanged: ((Int) -> Void)? = nil

    /// Defines the layout style for the tab bar
    private var layoutStyle: TabLayoutStyle

    /// Configures the layout properties of the tab bar
    private var layoutConfig: TabBarLayoutConfig

    /// Defines the visual style of individual tab buttons
    private var buttonStyle: TabButtonStyle

    /// Defines the style of the tab indicator
    private var indicatorStyle: TabIndicatorStyle

    /// Controls whether swipe gesture is enabled for tab content
    private var isSwipeEnabled: Bool = true

    /// Initializes `TabPagerX` using a result builder that returns an array of `TabPagerItem`.
    /// - Parameters:
    ///   - selectedIndex: A binding to the currently selected tab index.
    ///   - initialIndex: Optional index to select when the view first appears. Defaults to `nil`.
    ///   - content: A builder closure that returns an array of `TabPagerItem` to populate the tabs.
    public init(
        selectedIndex: Binding<Int>,
        initialIndex: Int? = nil,
        @TabPagerBuilder content: () -> [TabPagerItem]
    ) {
        self._selectedIndex = selectedIndex
        self.initialIndex = initialIndex
        let items = content()
        self.titles = items.map { $0.title }
        self.views = items.map { AnyView($0.view) }
        self.layoutStyle = .fixed
        self.layoutConfig = .default
        self.buttonStyle = .default
        self.indicatorStyle = .default
    }

    /// Initializes a `TabPagerX` with a static array of `TabPagerItem`
    /// - Parameters:
    ///   - selectedIndex: A binding to the currently selected tab index
    ///   - initialIndex: Optional initial index to select when the view appears
    ///   - items: An array of `TabPagerItem` representing the tabs and their content
    public init(
        selectedIndex: Binding<Int>,
        initialIndex: Int? = nil,
        items: [TabPagerItem]
    ) {
        self._selectedIndex = selectedIndex
        self.initialIndex = initialIndex
        self.titles = items.map { $0.title }
        self.views = items.map { AnyView($0.view) }
        self.layoutStyle = .fixed
        self.layoutConfig = .default
        self.buttonStyle = .default
        self.indicatorStyle = .default
    }

    public var body: some View {
        VStack(spacing: 0) {
            TabBar(
                tabs: .constant(titles),
                selectedIndex: $selectedIndex,
                layoutStyle: layoutStyle,
                layoutConfig: layoutConfig,
                buttonStyle: buttonStyle,
                indicatorStyle: indicatorStyle
            )
            TabContent(
                selectedIndex: $selectedIndex,
                tabCount: views.count,
                isSwipeEnabled: .constant(isSwipeEnabled),
                content: { views[$0] }
            )
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            if let initialIndex = initialIndex,
               initialIndex >= 0 && initialIndex < titles.count {
                // Forcefully set the initial index when the view appears
                selectedIndex = initialIndex

            } else if selectedIndex < 0 || selectedIndex >= titles.count {
                // Ensure the selected index remains within a valid range
                selectedIndex = 0
            }
        }
        .onChange(of: selectedIndex) { newIndex in
            onTabChanged?(newIndex)
        }
    }
}

public extension TabPagerX {
    /// Modifier to customize TabBar layout style
    func tabBarLayoutStyle(_ style: TabLayoutStyle) -> Self {
        var new = self
        new.layoutStyle = style
        return new
    }

    /// Modifier to customize TabBar layout configuration
    func tabBarLayoutConfig(
        buttonSpacing: CGFloat = 0,
        sidePadding: CGFloat = 0
    ) -> Self {
        var new = self
        new.layoutConfig = TabBarLayoutConfig(
            buttonSpacing: buttonSpacing,
            sidePadding: sidePadding
        )
        return new
    }

    /// Modifier to customize TabButton style
    func tabButtonStyle(
        normal: ButtonStateStyle,
        selected: ButtonStateStyle? = nil,
        padding: EdgeInsets? = nil,
        cornerRadius: CGFloat? = nil
    ) -> Self {
        var new = self
        new.buttonStyle = TabButtonStyle(
            normal: normal,
            selected: selected,
            padding: padding,
            cornerRadius: cornerRadius
        )
        return new
    }

    /// Modifier to customize TabIndicator style
    func tabIndicatorStyle(
        height: CGFloat? = nil,
        color: Color? = nil,
        horizontalInset: CGFloat? = nil,
        cornerRadius: CGFloat? = nil,
        animationDuration: Double? = nil
    ) -> Self {
        var new = self
        new.indicatorStyle = TabIndicatorStyle(
            height: height,
            color: color,
            horizontalInset: horizontalInset,
            cornerRadius: cornerRadius,
            animationDuration: animationDuration
        )
        return new
    }

    /// Modifier to observe tab index changes
    func onTabChanged(_ action: @escaping (Int) -> Void) -> Self {
        var new = self
        new.onTabChanged = action
        return new
    }

    /// Modifier to enable or disable swipe gesture for tab content
    func contentSwipeEnabled(_ enabled: Bool) -> Self {
        var new = self
        new.isSwipeEnabled = enabled
        return new
    }
}
