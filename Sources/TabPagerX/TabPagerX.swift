import SwiftUI

/// A flexible tab pager that works with any Identifiable data type
/// Provides a more intuitive API using closures for content and tab titles
public struct TabPagerX<Data, Content, TabTitle>: View 
where Data: Identifiable & Equatable, Content: View, TabTitle: View {

    /// Index of the selected tab - synchronizes with external state
    @Binding var selectedIndex: Int

    /// Optional initial index to select when the view first appears
    /// Only applied once when the view appears, then becomes independent of selectedIndex
    private let initialIndex: Int?

    /// Array of data items that populate the tabs
    private let items: [Data]

    /// Closure that creates content view for each data item
    @ViewBuilder private let content: (Data) -> Content

    /// Closure that creates tab title view for each data item
    @ViewBuilder private let tabTitle: (Data, Bool) -> TabTitle

    /// Callback when tab changes
    private var onTabChanged: ((Int) -> Void)? = nil

    /// Defines the layout style for the tab bar
    private var layoutStyle: TabLayoutStyle = .fixed

    /// Configures the layout properties of the tab bar
    private var layoutConfig: TabBarLayoutConfig = .default

    /// Defines the style of the tab indicator
    private var indicatorStyle: TabIndicatorStyle = .default

    /// Controls whether swipe gesture is enabled for tab content
    private var isSwipeEnabled: Bool = true

    /// Separator style between TabBar and TabContent
    private var separatorStyle: TabBarSeparatorStyle = .none

    /// Tracks whether initialIndex has been applied to prevent re-application
    @State private var hasAppliedInitialIndex = false

    /// Initializes `TabPagerX` with generic data and view builders
    /// - Parameters:
    ///   - selectedIndex: A binding to the currently selected tab index
    ///   - initialIndex: Optional index to select when the view first appears
    ///   - items: Array of data items that populate the tabs
    ///   - content: Closure that creates content view for each data item
    ///   - tabTitle: Closure that creates tab title view for each data item
    public init(
        selectedIndex: Binding<Int>,
        initialIndex: Int? = nil,
        items: [Data],
        @ViewBuilder content: @escaping (Data) -> Content,
        @ViewBuilder tabTitle: @escaping (Data, Bool) -> TabTitle
    ) {
        self._selectedIndex = selectedIndex
        self.initialIndex = initialIndex
        self.items = items
        self.content = content
        self.tabTitle = tabTitle
    }

    public var body: some View {
        VStack(spacing: 0) {
            TabBar(
                tabTitleBuilders: tabTitleBuilders,
                selectedIndex: $selectedIndex,
                layoutStyle: layoutStyle,
                layoutConfig: layoutConfig,
                indicatorStyle: indicatorStyle
            )

            if !separatorStyle.isHidden {
                Rectangle()
                    .fill(separatorStyle.color)
                    .frame(height: separatorStyle.height)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, separatorStyle.horizontalPadding)
            }

            TabContent(
                selectedIndex: $selectedIndex,
                tabCount: items.count,
                isSwipeEnabled: .constant(isSwipeEnabled),
                content: { index in
                    content(items[index])
                }
            )
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            setupInitialIndexOnce()
        }
        .onChange(of: items) { _ in
            // Handle dynamic items changes
            hasAppliedInitialIndex = false
            clampSelectedIndex()
            setupInitialIndexOnce()
        }
        .onChange(of: selectedIndex) { newIndex in
            onTabChanged?(newIndex)
        }
    }

    /// Computed property that creates title builders from data items
    private var tabTitleBuilders: [(_ isSelected: Bool) -> AnyView] {
        items.enumerated().map { index, item in
            { isSelected in
                AnyView(tabTitle(item, isSelected))
            }
        }
    }
}

private extension TabPagerX {
    /// Applies initialIndex only once when needed
    private func setupInitialIndexOnce() {
        guard !hasAppliedInitialIndex else { return }

        if let initialIndex = initialIndex,
           initialIndex >= 0 && initialIndex < items.count {
            selectedIndex = initialIndex
            hasAppliedInitialIndex = true

        } else {
            clampSelectedIndex()
            hasAppliedInitialIndex = true
        }
    }

    /// Validates and corrects selectedIndex when items change
    private func clampSelectedIndex() {
        if items.isEmpty {
            selectedIndex = 0

        } else if selectedIndex >= items.count {
            selectedIndex = items.count - 1

        } else if selectedIndex < 0 {
            selectedIndex = 0
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

    /// Configure the separator between TabBar and content
    func tabBarSeparator(
        color: Color = .gray.opacity(0.2),
        height: CGFloat = 1,
        horizontalPadding: CGFloat = 0,
        isHidden: Bool = false
    ) -> Self {
        var new = self
        new.separatorStyle = TabBarSeparatorStyle(
            color: color,
            height: height,
            horizontalPadding: horizontalPadding,
            isHidden: isHidden
        )
        return new
    }
}
