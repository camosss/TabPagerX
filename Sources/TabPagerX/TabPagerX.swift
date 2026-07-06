import SwiftUI

/// A flexible tab pager that works with any Identifiable data type
/// Provides a more intuitive API using closures for content and tab labels
public struct TabPagerX<Item, Content, Label>: View
where Item: Identifiable & Equatable, Content: View, Label: View {

    /// How the selected tab is bound to external state
    private enum SelectionMode {
        case index(Binding<Int>)
        case id(Binding<Item.ID?>)
    }

    private let selectionMode: SelectionMode

    /// Optional initial index to select when the view first appears (index mode only)
    /// Only applied once when the view appears, then becomes independent of selectedIndex
    private let initialIndex: Int?

    /// Array of data items that populate the tabs
    private let items: [Item]

    /// Closure that creates content view for each data item
    @ViewBuilder private let content: (Item) -> Content

    /// Closure that creates tab label view for each data item
    @ViewBuilder private let label: (Item, TabState) -> Label

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

    /// Tracks whether initialIndex has been applied (index mode only)
    @State private var hasAppliedInitialIndex = false

    /// Continuous scroll progress from page swipe (-1 to 1)
    @State private var scrollProgress: CGFloat = 0

    /// Initializes `TabPagerX` with id-based selection
    /// Selection follows the item, so it survives reorders and removals,
    /// and deep links can select a tab by id without knowing its position
    /// - Parameters:
    ///   - selection: A binding to the selected item's id — nil until items arrive,
    ///     then the first item is selected automatically (preset an id to start elsewhere)
    ///   - items: Array of data items that populate the tabs
    ///   - content: Closure that creates content view for each data item
    ///   - label: Closure that creates tab label view for each data item
    public init(
        selection: Binding<Item.ID?>,
        items: [Item],
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder label: @escaping (Item, TabState) -> Label
    ) {
        self.selectionMode = .id(selection)
        self.initialIndex = nil
        self.items = items
        self.content = content
        self.label = label
    }

    /// Initializes `TabPagerX` with index-based selection
    @available(*, deprecated, message: "Use init(selection:items:content:label:) — id-based selection survives reorders and removals, and TabState enables real-time label effects")
    public init(
        selectedIndex: Binding<Int>,
        initialIndex: Int? = nil,
        items: [Item],
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder tabTitle: @escaping (Item, Bool) -> Label
    ) {
        self.selectionMode = .index(selectedIndex)
        self.initialIndex = initialIndex
        self.items = items
        self.content = content
        self.label = { item, state in tabTitle(item, state.isSelected) }
    }

    public var body: some View {
        VStack(spacing: 0) {
            TabBar(
                labelBuilders: labelBuilders,
                selectedIndex: selectedIndexBinding,
                stateFor: tabState(for:),
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

            if !items.isEmpty {
                TabContentContainer(
                    selectedIndex: selectedIndexBinding,
                    scrollProgress: $scrollProgress,
                    itemIDs: items.map { AnyHashable($0.id) },
                    isSwipeEnabled: isSwipeEnabled,
                    content: { index in
                        content(items[safe: index] ?? items[0])
                    }
                )
            } else {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            resolveSelection()
        }
        .onChangeCompat(of: items) {
            resolveSelection()
        }
        .onChangeCompat(of: selectedIndex) {
            onTabChanged?(selectedIndex)
        }
    }

    /// Int binding used by the tab bar and page controller
    /// In id mode it is derived from the id binding on the fly
    private var selectedIndexBinding: Binding<Int> {
        switch selectionMode {

        case .index(let binding):
            return binding

        case .id(let binding):
            return Binding(
                get: {
                    guard let id = binding.wrappedValue,
                          let index = items.firstIndex(where: { $0.id == id })
                    else { return 0 }
                    return index
                },
                set: { newIndex in
                    guard let item = items[safe: newIndex] else { return }
                    binding.wrappedValue = item.id
                }
            )
        }
    }

    private var selectedIndex: Int {
        selectedIndexBinding.wrappedValue
    }

    private var displayIndex: Int {
        TabPagerHelper.displayIndex(
            selectedIndex: selectedIndex,
            scrollProgress: scrollProgress,
            itemCount: items.count
        )
    }

    private var labelBuilders: [(TabState) -> Label] {
        items.map { item in
            { state in
                label(item, state)
            }
        }
    }

    private func tabState(for index: Int) -> TabState {
        TabState(
            isSelected: index == displayIndex,
            selectionProgress: TabPagerHelper.selectionProgress(
                for: index,
                selectedIndex: TabPagerHelper.clampIndex(selectedIndex, itemCount: items.count),
                scrollProgress: scrollProgress
            )
        )
    }
}

private extension TabPagerX {
    /// Ensures the selection points at a valid tab — called on appear and whenever items change
    private func resolveSelection() {
        switch selectionMode {

        case .index(let binding):
            guard !items.isEmpty else { return }

            if !hasAppliedInitialIndex {
                if let initialIndex = initialIndex,
                   initialIndex >= 0 && initialIndex < items.count {
                    binding.wrappedValue = initialIndex
                } else {
                    clampIndexBinding(binding)
                }
                hasAppliedInitialIndex = true
            } else {
                clampIndexBinding(binding)
            }

        case .id(let binding):
            // Keep a preset id while items are still loading — it may become valid
            guard !items.isEmpty else { return }

            if let id = binding.wrappedValue,
               items.contains(where: { $0.id == id }) {
                return
            }
            binding.wrappedValue = items[0].id
        }
    }

    private func clampIndexBinding(_ binding: Binding<Int>) {
        let clamped = TabPagerHelper.clampIndex(binding.wrappedValue, itemCount: items.count)
        if binding.wrappedValue != clamped {
            binding.wrappedValue = clamped
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
        let id: String
        let title: String
        let content: String
        let color: Color
        let icon: String
    }

    @State private var selection: String? = nil
    @State private var items: [DynamicTabItem] = []
    @State private var loadCount = 0

    var body: some View {
        VStack {
            Text("Dynamic Tabs (API Simulation)")
                .font(.headline)
                .padding()

            HStack {
                Text("Selection: \(selection ?? "nil")")
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
                selection: $selection,
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

                    Text("Load #\(loadCount)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            } label: { item, state in
                HStack {
                    Image(systemName: item.icon)
                        .font(.caption)
                    Text(item.title)
                }
                .font(state.isSelected ? .headline : .body)
                .foregroundColor(item.color.opacity(0.4 + 0.6 * state.selectionProgress))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            .tabBarLayoutStyle(.scrollable)
            .tabIndicatorStyle(height: 3, color: .green, horizontalInset: 8)
        }
        .onAppear {
            loadData()
        }
    }

    private func loadData() {
        loadCount += 1

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            items = [
                DynamicTabItem(id: "news", title: "News", content: "Latest news from API", color: .red, icon: "newspaper"),
                DynamicTabItem(id: "sports", title: "Sports", content: "Sports updates", color: .orange, icon: "sportscourt"),
                DynamicTabItem(id: "tech", title: "Tech", content: "Technology news", color: .blue, icon: "laptopcomputer"),
                DynamicTabItem(id: "weather", title: "Weather", content: "Weather forecast", color: .cyan, icon: "cloud.sun"),
                DynamicTabItem(id: "finance", title: "Finance", content: "Market updates", color: .green, icon: "chart.line.uptrend.xyaxis")
            ]
        }
    }
}
#endif
