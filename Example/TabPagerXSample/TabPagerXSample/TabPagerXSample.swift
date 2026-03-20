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
// 모든 탭이 동일한 뷰 구조를 사용하는 기본 예시

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
        // 고정 폭 레이아웃 (기본값)
        .tabBarLayoutStyle(.fixed)
        .tabIndicatorStyle(height: 3, color: .blue, horizontalInset: 16)
        .onTabChanged { index in
            print("Selected tab: \(index)")
        }
    }
}

// MARK: - 2. Different Views by Type
// 아이템 타입에 따라 다른 뷰를 렌더링하는 예시

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
            // switch문으로 타입별 다른 뷰 렌더링
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
// 탭이 많을 때 스크롤 가능한 레이아웃 예시
// 스와이프 시 인디케이터가 실시간으로 손가락을 따라 이동

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
        // 스크롤 가능 레이아웃 + 버튼 간격 및 좌우 패딩 설정
        .tabBarLayoutStyle(.scrollable)
        .tabBarLayoutConfig(buttonSpacing: 4, sidePadding: 12)
        .tabIndicatorStyle(height: 3, color: .blue, cornerRadius: 1.5)
    }
}

// MARK: - 4. Separator Style
// 탭바와 콘텐츠 사이에 구분선을 추가하는 예시

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
        // 탭바 하단 구분선 (.tabBarSeparator)
        .tabBarSeparator(
            color: .gray.opacity(0.3),
            height: 1
        )
    }
}

// MARK: - 5. Indicator Customization
// 인디케이터 스타일을 다양하게 커스터마이징하는 예시

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
        // 높은 cornerRadius + horizontalInset으로 둥근 필 인디케이터
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
// 스와이프 비활성화 시 탭 전환 애니메이션도 함께 제거되는 예시
// contentSwipeEnabled(false) → 탭 클릭 시 즉시 전환 (슬라이드 애니메이션 없음)

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
            // 스와이프 비활성화 → 탭 클릭 시 슬라이드 애니메이션도 제거됨
            .contentSwipeEnabled(false)
        }
    }
}

// MARK: - 7. Static Tabs (initialIndex)
// initialIndex로 최초 표시 탭을 지정하는 예시

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
            Text("initialIndex = 2 → 3번째 탭(Profile)부터 시작")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()

            Text("Selected Index: \(selectedIndex)")
                .font(.caption)
                .foregroundColor(.secondary)

            TabPagerX(
                selectedIndex: $selectedIndex,
                // 최초 표시 탭 지정 (한 번만 적용됨)
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
// 비동기 데이터 로딩 시 isLoading guard 없이 안전하게 동작하는 예시
// items가 []로 시작 → 데이터 도착 시 자동으로 탭 렌더링

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

            // isLoading guard 불필요!
            // items가 빈 배열이어도 안전하게 렌더링되고,
            // 데이터가 도착하면 자동으로 탭이 표시됨
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

        // 1.5초 후 API 데이터 도착 시뮬레이션
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
