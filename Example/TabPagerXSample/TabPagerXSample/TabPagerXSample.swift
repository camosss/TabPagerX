import SwiftUI
import TabPagerX

struct TabPagerXSampleHome: View {
    var body: some View {
        NavigationView {
            List {
                Section("Basic Usage") {
                    NavigationLink("1. Same Content", destination: SameViewSample())
                    NavigationLink("2. Different Views by Type", destination: DifferentViewSample())
                }
                Section("Layout & Style") {
                    NavigationLink("3. Scrollable Tabs", destination: ScrollableTabsSample())
                    NavigationLink("4. Separator Style", destination: SeparatorSample())
                    NavigationLink("5. Indicator Customization", destination: IndicatorCustomSample())
                }
                Section("Swipe Behavior") {
                    NavigationLink("6. Swipe Disabled (Instant Switch)", destination: SwipeDisabledSample())
                }
                Section("Initialization & Dynamic Data") {
                    NavigationLink("7. Static Tabs (initialIndex)", destination: StaticTabsSample())
                    NavigationLink("8. Dynamic Tabs (No Guard Needed)", destination: DynamicTabsSample())
                }
            }
            .navigationTitle("TabPagerX Samples")
        }
    }
}

// MARK: - 1. Same Content
// All tabs share the same view structure with different data

struct SameViewSample: View {

    struct TabItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let content: String
        let color: Color
    }

    @State private var selectedIndex = 0

    private let items = [
        TabItem(title: "Home", content: "Welcome to Home", color: .blue),
        TabItem(title: "Search", content: "Search content", color: .green),
        TabItem(title: "Profile", content: "Profile content", color: .orange)
    ]

    var body: some View {
        TabPagerX(
            selectedIndex: $selectedIndex,
            items: items
        ) { item in
            VStack {
                Text(item.content)
                    .font(.title2)
                    .foregroundColor(item.color)

                Rectangle()
                    .fill(item.color)
                    .frame(height: 200)
                    .cornerRadius(12)
            }
            .padding()

        } tabTitle: { item, isSelected in
            Text(item.title)
                .font(isSelected ? .headline : .body)
                .foregroundColor(isSelected ? item.color : .secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
        }
        // Fixed-width layout (default)
        .tabBarLayoutStyle(.fixed)
        .tabIndicatorStyle(height: 3, color: .blue, horizontalInset: 16)
        .onTabChanged { index in
            print("Selected tab: \(index)")
        }
    }
}

// MARK: - 2. Different Views by Type
// Renders different views based on each item's type

struct DifferentViewSample: View {

    struct MixedTabItem: Identifiable, Equatable {
        let id = UUID()
        let type: TabItemType
        let title: String

        enum TabItemType: Equatable {
            case text(String)
            case image(String)
            case custom
        }
    }

    @State private var selectedIndex = 0

    private let items = [
        MixedTabItem(type: .text("Hello World"), title: "Text"),
        MixedTabItem(type: .image("star.fill"), title: "Image"),
        MixedTabItem(type: .custom, title: "Custom")
    ]

    var body: some View {
        TabPagerX(
            selectedIndex: $selectedIndex,
            items: items
        ) { item in
            // Switch on item type to render different views
            switch item.type {
            case .text(let content):
                Text(content)
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue.opacity(0.1))

            case .image(let imageName):
                VStack {
                    Image(systemName: imageName)
                        .font(.system(size: 60))
                        .foregroundColor(.yellow)
                    Text("Image View")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.yellow.opacity(0.1))

            case .custom:
                VStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 100, height: 100)
                    Text("Custom View")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.purple.opacity(0.1))
            }

        } tabTitle: { item, isSelected in
            HStack {
                if case .image = item.type {
                    Image(systemName: "photo")
                        .font(.caption)
                } else if case .custom = item.type {
                    Image(systemName: "star.circle")
                        .font(.caption)
                }
                Text(item.title)
            }
            .foregroundColor(isSelected ? .blue : .secondary)
            .font(isSelected ? .headline : .body)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .tabBarLayoutStyle(.fixed)
        .tabIndicatorStyle(height: 4, color: .purple)
    }
}

// MARK: - 3. Scrollable Tabs
// Scrollable layout for many tabs
// Indicator tracks finger movement in real-time during swipe

struct ScrollableTabsSample: View {

    struct CategoryItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let emoji: String
        let color: Color
    }

    @State private var selectedIndex = 0

    private let items = [
        CategoryItem(title: "All", emoji: "🌐", color: .blue),
        CategoryItem(title: "Music", emoji: "🎵", color: .pink),
        CategoryItem(title: "Sports", emoji: "⚽", color: .green),
        CategoryItem(title: "Gaming", emoji: "🎮", color: .purple),
        CategoryItem(title: "Food", emoji: "🍕", color: .orange),
        CategoryItem(title: "Travel", emoji: "✈️", color: .cyan),
        CategoryItem(title: "Science", emoji: "🔬", color: .teal),
        CategoryItem(title: "Art", emoji: "🎨", color: .indigo),
    ]

    var body: some View {
        TabPagerX(
            selectedIndex: $selectedIndex,
            items: items
        ) { item in
            VStack(spacing: 16) {
                Text(item.emoji)
                    .font(.system(size: 80))
                Text(item.title)
                    .font(.title)
                    .foregroundColor(item.color)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(item.color.opacity(0.05))

        } tabTitle: { item, isSelected in
            Text("\(item.emoji) \(item.title)")
                .font(isSelected ? .headline : .subheadline)
                .foregroundColor(isSelected ? item.color : .secondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
        }
        // Scrollable layout with button spacing and side padding
        .tabBarLayoutStyle(.scrollable)
        .tabBarLayoutConfig(buttonSpacing: 4, sidePadding: 12)
        .tabIndicatorStyle(height: 3, color: .blue, cornerRadius: 1.5)
    }
}

// MARK: - 4. Separator Style
// Adds a separator line between the tab bar and content area

struct SeparatorSample: View {

    struct TabItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let content: String
    }

    @State private var selectedIndex = 0

    private let items = [
        TabItem(title: "Feed", content: "Feed content area"),
        TabItem(title: "Explore", content: "Explore content area"),
        TabItem(title: "Notifications", content: "Notifications content area"),
    ]

    var body: some View {
        TabPagerX(
            selectedIndex: $selectedIndex,
            items: items
        ) { item in
            VStack {
                Text(item.content)
                    .font(.title3)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.top, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))

        } tabTitle: { item, isSelected in
            Text(item.title)
                .font(isSelected ? .headline : .body)
                .foregroundColor(isSelected ? .primary : .secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
        }
        .tabBarLayoutStyle(.fixed)
        .tabIndicatorStyle(height: 2, color: .blue)
        // Separator between tab bar and content
        .tabBarSeparator(
            color: .gray.opacity(0.3),
            height: 1
        )
    }
}

// MARK: - 5. Indicator Customization
// Customize indicator height, color, cornerRadius, inset, and animation duration

struct IndicatorCustomSample: View {

    struct TabItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
    }

    @State private var selectedIndex = 0

    private let items = [
        TabItem(title: "Rounded"),
        TabItem(title: "Wide"),
        TabItem(title: "Thin"),
    ]

    var body: some View {
        TabPagerX(
            selectedIndex: $selectedIndex,
            items: items
        ) { item in
            Text("Content for \(item.title)")
                .font(.title2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        } tabTitle: { item, isSelected in
            Text(item.title)
                .font(isSelected ? .headline : .body)
                .foregroundColor(isSelected ? .white : .secondary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color.clear)
                )
        }
        .tabBarLayoutStyle(.fixed)
        // Rounded pill indicator with cornerRadius + horizontalInset
        .tabIndicatorStyle(
            height: 4,
            color: .orange,
            horizontalInset: 20,
            cornerRadius: 2,
            animationDuration: 0.25
        )
    }
}

// MARK: - 6. Swipe Disabled (Instant Switch)
// When swipe is disabled, tab transition animation is also removed
// contentSwipeEnabled(false) → tapping a tab switches instantly (no slide animation)

struct SwipeDisabledSample: View {

    struct TabItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let color: Color
    }

    @State private var selectedIndex = 0

    private let items = [
        TabItem(title: "Tab A", color: .red),
        TabItem(title: "Tab B", color: .blue),
        TabItem(title: "Tab C", color: .green),
    ]

    var body: some View {
        VStack(spacing: 0) {
            Text("Swipe disabled → Instant tab switch")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.vertical, 8)

            TabPagerX(
                selectedIndex: $selectedIndex,
                items: items
            ) { item in
                VStack {
                    Text(item.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(item.color)
                    Text("Tap a tab to switch instantly")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(item.color.opacity(0.1))

            } tabTitle: { item, isSelected in
                Text(item.title)
                    .font(isSelected ? .headline : .body)
                    .foregroundColor(isSelected ? item.color : .secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
            .tabBarLayoutStyle(.fixed)
            .tabIndicatorStyle(height: 3, color: .red)
            // Disabling swipe also removes slide animation on tab tap
            .contentSwipeEnabled(false)
        }
    }
}

// MARK: - 7. Static Tabs (initialIndex)
// Specify which tab to show first using initialIndex (applied once on appearance)

struct StaticTabsSample: View {

    struct StaticTabItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let content: String
        let color: Color
    }

    @State private var selectedIndex = 0

    private let items = [
        StaticTabItem(title: "Home", content: "Welcome to Home", color: .blue),
        StaticTabItem(title: "Search", content: "Search content", color: .green),
        StaticTabItem(title: "Profile", content: "Profile content", color: .orange),
        StaticTabItem(title: "Settings", content: "Settings content", color: .purple)
    ]

    var body: some View {
        VStack {
            Text("initialIndex = 2 → Starts at 3rd tab (Profile)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()

            Text("Selected Index: \(selectedIndex)")
                .font(.caption)
                .foregroundColor(.secondary)

            TabPagerX(
                selectedIndex: $selectedIndex,
                // Start at 3rd tab (applied once on first appearance)
                initialIndex: 2,
                items: items
            ) { item in
                VStack {
                    Text(item.content)
                        .font(.title2)
                        .foregroundColor(item.color)

                    Rectangle()
                        .fill(item.color)
                        .frame(height: 150)
                        .cornerRadius(12)
                }
                .padding()

            } tabTitle: { item, isSelected in
                Text(item.title)
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
            .tabIndicatorStyle(height: 3, color: .blue, horizontalInset: 8)
        }
    }
}

// MARK: - 8. Dynamic Tabs (No Guard Needed)
// Safely handles async data loading without isLoading guard
// Starts with items = [] → tabs render automatically when data arrives

struct DynamicTabsSample: View {

    struct DynamicTabItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let content: String
        let color: Color
        let icon: String
    }

    @State private var selectedIndex = 0
    @State private var items: [DynamicTabItem] = []
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

            // No isLoading guard needed!
            // Safe with empty items — tabs appear automatically when data loads
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

                    Text("Load #\(loadCount)")
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
            .tabBarSeparator(color: .gray.opacity(0.2), height: 1)
        }
        .onAppear {
            loadData()
        }
    }

    private func loadData() {
        items = []
        loadCount += 1

        // Simulate API response after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            items = [
                DynamicTabItem(title: "News", content: "Latest news from API", color: .red, icon: "newspaper"),
                DynamicTabItem(title: "Sports", content: "Sports updates", color: .orange, icon: "sportscourt"),
                DynamicTabItem(title: "Tech", content: "Technology news", color: .blue, icon: "laptopcomputer"),
                DynamicTabItem(title: "Weather", content: "Weather forecast", color: .cyan, icon: "cloud.sun"),
                DynamicTabItem(title: "Finance", content: "Market updates", color: .green, icon: "chart.line.uptrend.xyaxis")
            ]
        }
    }
}
