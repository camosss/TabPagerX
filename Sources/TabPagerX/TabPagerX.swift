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

    /// Continuous scroll progress from page swipe (-1 to 1)
    @State private var scrollProgress: CGFloat = 0

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
                scrollProgress: scrollProgress,
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

            TabContentContainer(
                selectedIndex: $selectedIndex,
                scrollProgress: $scrollProgress,
                tabCount: items.count,
                isSwipeEnabled: isSwipeEnabled,
                content: { index in
                    content(items[max(0, min(index, items.count - 1))])
                }
            )
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            setupInitialIndexOnce()
        }
        .onChangeCompat(of: items) {
            clampSelectedIndex()
            if !hasAppliedInitialIndex {
                setupInitialIndexOnce()
            }
        }
        .onChangeCompat(of: selectedIndex) {
            onTabChanged?(selectedIndex)
        }
    }

    private var tabTitleBuilders: [(_ isSelected: Bool) -> TabTitle] {
        items.map { item in
            { isSelected in
                tabTitle(item, isSelected)
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

#if DEBUG
#Preview(body: {
    DynamicTabsSample()
})

struct DynamicTabsSample: View {

    struct DynamicTabItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let content: String
        let color: Color
        let icon: String
        let source: String
    }

    @State private var selectedIndex = 0
    @State private var items: [DynamicTabItem] = []
    @State private var isLoading = true
    @State private var loadCount = 0

    var body: some View {
        VStack {
            Text("Dynamic Tabs (API Simulation)")
                .font(.headline)
                .padding()

            HStack {
                Text("Selected Index: \(selectedIndex)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Button("Reload Data") {
                    loadData()
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal)

            TabPagerX(
                    selectedIndex: $selectedIndex,
                    initialIndex: 1,
                    items: items
                ) { item in
                    VStack {
                        Text(item.content)
                            .font(.title2)
                            .foregroundColor(item.color)

                        Rectangle()
                            .fill(item.color)
                            .frame(height: 120)
                            .cornerRadius(12)

                        Text("Load #\(loadCount) - \(item.source)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } tabTitle: { item, isSelected in
                    HStack {
                        Image(systemName: item.icon)
                            .font(.caption)
                        Text(item.title)
                    }
                    .font(isSelected ? .headline : .body)
                    .foregroundColor(isSelected ? item.color : .secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isSelected ? item.color.opacity(0.1) : Color.clear)
                    )
                }
                .tabBarLayoutStyle(.scrollable)
                .tabIndicatorStyle(height: 3, color: .green, horizontalInset: 8)
                .onTabChanged { index in
                    print("Selected tab: \(index)")
                }
        }
        .onAppear {
            loadData()
        }
    }

    private func loadData() {
        isLoading = true
        loadCount += 1

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let apiData = [
                DynamicTabItem(title: "News", content: "Latest news from API", color: .red, icon: "newspaper", source: "API"),
                DynamicTabItem(title: "Sports", content: "Sports updates", color: .orange, icon: "sportscourt", source: "API"),
                DynamicTabItem(title: "Tech", content: "Technology news", color: .blue, icon: "laptopcomputer", source: "API"),
                DynamicTabItem(title: "Weather", content: "Weather forecast", color: .cyan, icon: "cloud.sun", source: "API"),
                DynamicTabItem(title: "Finance", content: "Market updates", color: .green, icon: "chart.line.uptrend.xyaxis", source: "API")
            ]

            items = apiData
            isLoading = false
        }
    }
}
#endif
