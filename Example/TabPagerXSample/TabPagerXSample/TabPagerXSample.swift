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
                Section("Initialization Scenarios") {
                    NavigationLink("3. Static Tabs (initialIndex)", destination: StaticTabsSample())
                    NavigationLink("4. Dynamic Tabs (API Data)", destination: DynamicTabsSample())
                }
            }
            .navigationTitle("TabPagerX Samples")
        }
    }
}

// MARK: - Basic Usage

/// Case 1: `Same View`
/// - All items use the same view structure
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

            // All items use the same view structure
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
        .tabBarLayoutStyle(.fixed)
        .tabIndicatorStyle(height: 3, color: .blue, horizontalInset: 16)
        .onTabChanged { index in
            print("Selected tab: \(index)")
        }
    }
}

/// Case 2: `Different Views by Type`
/// - Generate different views depending on the item type
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

            // Generate different views depending on the item type
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
        .onTabChanged { index in
            print("Selected tab: \(index)")
        }
    }
}

// MARK: - Initialization Scenarios

/// Case 3: Static Tabs with initialIndex
/// - Demonstrates initialIndex behavior with static data
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
            Text("Static Tabs with initialIndex = 2")
                .font(.headline)
                .padding()

            Text("Selected Index: \(selectedIndex)")
                .font(.caption)
                .foregroundColor(.secondary)

            TabPagerX(
                selectedIndex: $selectedIndex,
                initialIndex: 2, // Start with 3rd tab (index 2)
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
            .onTabChanged { index in
                print("Selected tab: \(index)")
            }
        }
    }
}


/// Case 4: Dynamic Tabs with API Data
/// - Demonstrates initialIndex behavior with dynamic data loading
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
            
            if isLoading {
                VStack {
                    ProgressView()
                    Text("Loading API data...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                TabPagerX(
                    selectedIndex: $selectedIndex,
                    initialIndex: 1,  // Start with 2nd tab when data loads
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
