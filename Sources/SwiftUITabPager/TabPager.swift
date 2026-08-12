import SwiftUI

/// A flexible tab pager that works with any Identifiable data type
/// Provides a more intuitive API using closures for content and tab labels
public struct TabPager<Item, Content, Label>: View
where Item: Identifiable & Equatable, Content: View, Label: View {

    /// Binding to the selected item's id
    private let selection: Binding<Item.ID?>

    /// Array of data items that populate the tabs
    private let items: [Item]

    /// Closure that creates content view for each data item
    @ViewBuilder private let content: (Item) -> Content

    /// Closure that creates tab label view for each data item
    @ViewBuilder private let label: (Item, TabState) -> Label

    /// Callback when the selected item changes
    private var onTabChanged: ((Item) -> Void)? = nil

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

    /// Safe area edges the pager extends into.
    /// Fills the bottom safe area by default so full-bleed pages need no setup —
    /// opt out per usage with `contentRespectsSafeArea()`
    private var ignoredSafeAreaEdges: Edge.Set = .bottom

    /// Continuous scroll progress from page swipe (-1 to 1)
    @State private var scrollProgress: CGFloat = 0

    /// Initializes `TabPager` with id-based selection
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
        self.selection = selection
        self.items = items
        self.content = content
        self.label = label
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
                            // A page owns its whole area. Without this the page is
                            // sized to its content, so a ScrollView inside it lays
                            // out (and draws its scroll indicator) at content width
                            // instead of page width
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            // Each page is hosted in its own UIHostingController, which re-applies
                            // the safe area inside the page — propagate the ignored edges so page
                            // content actually reaches the screen edge (no-op when edges is empty)
                            .ignoresSafeArea(edges: ignoredSafeAreaEdges)
                    }
                )
            } else {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(edges: ignoredSafeAreaEdges)
        .onAppear {
            resolveSelection(in: items)
        }
        .onChangeCompat(of: items) { newItems in
            // Resolve against the value delivered by onChange — before iOS 17
            // the captured `items` here is still the previous array
            resolveSelection(in: newItems)
        }
        .onChangeCompat(of: selection.wrappedValue) { _ in
            // Keyed to the id, not the index — reordering items moves the
            // selected tab's position without changing which item is selected
            if let id = selection.wrappedValue,
               let item = items.first(where: { $0.id == id }) {
                onTabChanged?(item)
            }
        }
    }

    /// Int binding used by the tab bar and page controller,
    /// derived from the id binding on the fly
    private var selectedIndexBinding: Binding<Int> {
        Binding(
            get: {
                TabPagerSelection.index(of: selection.wrappedValue, in: items)
            },
            set: { newIndex in
                guard let item = items[safe: newIndex] else { return }
                selection.wrappedValue = item.id
            }
        )
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

private extension TabPager {
    /// Ensures the selection points at a valid tab — called on appear and whenever items change
    private func resolveSelection(in items: [Item]) {
        let resolved = TabPagerSelection.resolved(current: selection.wrappedValue, in: items)
        guard resolved != selection.wrappedValue else { return }
        selection.wrappedValue = resolved
    }
}

public extension TabPager {
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

    /// Modifier to apply a preset TabIndicator style (e.g. `.hidden`)
    func tabIndicatorStyle(_ style: TabIndicatorStyle) -> Self {
        var new = self
        new.indicatorStyle = style
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

    /// Modifier to observe changes of the selected item
    func onTabChanged(_ action: @escaping (Item) -> Void) -> Self {
        var new = self
        new.onTabChanged = action
        return new
    }

    /// Extends the pager into the given safe area edges.
    /// The bottom edge is already filled by default — use this to widen that
    /// (e.g. `[.bottom, .horizontal]`) rather than to turn it on
    func contentIgnoresSafeArea(edges: Edge.Set = .bottom) -> Self {
        var new = self
        new.ignoredSafeAreaEdges = edges
        return new
    }

    /// Keeps the pager inside the safe area — use when it sits above a tab bar
    /// or toolbar and content must not run underneath it
    func contentRespectsSafeArea() -> Self {
        var new = self
        new.ignoredSafeAreaEdges = []
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
