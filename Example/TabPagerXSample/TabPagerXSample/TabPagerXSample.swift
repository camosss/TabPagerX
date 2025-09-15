import SwiftUI
import TabPagerX

/// Home screen listing all TabPagerX usage examples
struct TabPagerXSampleHome: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("1. Fixed Layout Tabs", destination: FixedTabSample())
                NavigationLink("2. Fixed Layout Tabs with List", destination: FixedTabWithListSample())
                NavigationLink("3. Basic Scrollable Tabs", destination: BasicScrollableTabSample())
                NavigationLink("4. Generated Tabs from Data", destination: GeneratedTabsSample())
                NavigationLink("5. Mixed Content Tabs", destination: MixedContentTabsSample())
                NavigationLink("6. Custom Tab Views (Builder)", destination: CustomTabViewsSample())
                NavigationLink("7. Custom Tab Views (Array)", destination: CustomTabViewsArraySample())
                NavigationLink("8. Custom Tab Views (API)", destination: APITabViewsSample())
            }
            .navigationTitle("TabPagerX Samples")
        }
    }
}

/// Example demonstrating fixed-width tab layout
struct FixedTabSample: View {
    @State private var selectedIndex = 0

    var body: some View {
        TabPagerX(selectedIndex: $selectedIndex) {
            VStack {
                Spacer()
                Text("Tab One")
                    .font(.largeTitle)
                Spacer()
            }
            .tabTitle("One")

            VStack {
                Spacer()
                Text("Tab Two")
                    .font(.largeTitle)
                Spacer()
            }
            .tabTitle("Two")

            VStack {
                Spacer()
                Text("Tab Three")
                    .font(.largeTitle)
                Spacer()
            }
            .tabTitle("Three")
        }
        .tabBarLayoutStyle(.fixed)
        .onTabChanged { newIndex in
            print("Selected tab: \(newIndex)")
        }
    }
}

/// Example demonstrating fixed-width tab layout with List content
struct FixedTabWithListSample: View {
    @State private var selectedIndex = 0

    var body: some View {
        TabPagerX(selectedIndex: $selectedIndex) {
            List(0..<20) { item in
                Text("Item \(item) in First")
                    .padding()
            }
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabTitle("First")

            List(0..<20) { item in
                Text("Item \(item) in Second")
                    .padding()
            }
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabTitle("Second")

            List(0..<20) { item in
                Text("Item \(item) in Third")
                    .padding()
            }
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabTitle("Third")
        }
        .tabBarLayoutStyle(.fixed)
        .onTabChanged { newIndex in
            print("Selected tab: \(newIndex)")
        }
    }
}

/// Example demonstrating a scrollable tab bar
struct BasicScrollableTabSample: View {
    @State private var selectedIndex = 0

    var body: some View {
        TabPagerX(selectedIndex: $selectedIndex) {
            Text("Content for Home")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
                .tabTitle("Home")

            Text("Content for Profile")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
                .tabTitle("Profile")

            Text("Content for Settings")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
                .tabTitle("Settings")
        }
        .tabBarLayoutStyle(.scrollable)
        .tabButtonStyle(
            normal: ButtonStateStyle(font: .body, textColor: .gray, backgroundColor: .white),
            selected: ButtonStateStyle(font: .headline, textColor: .blue, backgroundColor: .white),
            padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
            cornerRadius: 8
        )
        .tabIndicatorStyle(
            height: 2,
            color: .blue,
            horizontalInset: 8,
            cornerRadius: 4,
            animationDuration: 0.25
        )
        .onTabChanged { newIndex in
            print("Selected tab: \(newIndex)")
        }
    }
}

/// Example demonstrating generating tabs from a fixed data list
struct GeneratedTabsSample: View {
    let titles = ["One", "Two", "Three"]
    @State private var selectedIndex = 0

    private var tabItems: [TabPagerItem] {
        titles.map { title in
            List(0..<20) { item in
                Text("Item \(item) in First")
                    .padding()
            }
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabTitle(title)
        }
    }

    var body: some View {
        VStack {
            TabPagerX(
                selectedIndex: $selectedIndex,
                items: tabItems
            )
            .tabBarLayoutStyle(.scrollable)
            .tabButtonStyle(
                normal: ButtonStateStyle(font: .body, textColor: .gray, backgroundColor: .white),
                selected: ButtonStateStyle(font: .headline, textColor: .blue, backgroundColor: .white),
                padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
                cornerRadius: 8
            )
            .tabIndicatorStyle(
                height: 2,
                color: .blue,
                horizontalInset: 8,
                cornerRadius: 4,
                animationDuration: 0.25
            )
            .onTabChanged { newIndex in
                print("Selected tab: \(newIndex)")
            }
        }
    }
}

/// Example demonstrating mixed content types per tab
struct MixedContentTabsSample: View {
    @State private var selectedIndex = 0

    var body: some View {
        TabPagerX(selectedIndex: $selectedIndex) {
            Text("simple text view")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabTitle("Text")

            VStack {
                Button(action: {
                    print("Button tapped")
                }) {
                    Text("Tap Me")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabTitle("Button")

            List(0..<50) { item in
                Text("List item \(item)")
            }
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabTitle("List")
        }
        .tabBarLayoutStyle(.fixed)
        .onTabChanged { newIndex in
            print("Selected tab: \(newIndex)")
        }
    }
}

// MARK: - Custom Tab Views Examples

/// Example demonstrating custom tab views with images and badges (Builder 방식)
struct CustomTabViewsSample: View {
    @State private var selectedIndex = 0

    var body: some View {
        TabPagerX(selectedIndex: $selectedIndex) {
            VStack {
                Spacer()
                Text("HOME")
                    .font(.largeTitle)
                Spacer()
            }
            .tabTitle {
                HStack(spacing: 4) {
                    Image(systemName: "house.fill")
                        .foregroundColor(selectedIndex == 0 ? .blue : .gray)
                    Text("home")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedIndex == 0 ? .blue : .gray)
                }
            }

            VStack {
                Spacer()
                Text("MESSAGE")
                    .font(.largeTitle)
                Spacer()
            }
            .tabTitle {
                HStack(spacing: 4) {
                    Image(systemName: "message.fill")
                        .foregroundColor(selectedIndex == 1 ? .blue : .gray)
                    Text("message")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedIndex == 1 ? .blue : .gray)
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                }
            }

            VStack {
                Spacer()
                Text("PROFILE")
                    .font(.largeTitle)
                Spacer()
            }
            .tabTitle {
                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .foregroundColor(selectedIndex == 2 ? .blue : .gray)
                    Text("profile")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedIndex == 2 ? .blue : .gray)
                }
            }
        }
        .tabBarLayoutStyle(.fixed)
        .tabButtonStyle(
            normal: ButtonStateStyle(font: .body, textColor: .gray, backgroundColor: .white),
            selected: ButtonStateStyle(font: .headline, textColor: .blue, backgroundColor: .white),
            padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
            cornerRadius: 8
        )
        .tabIndicatorStyle(
            height: 3,
            color: .blue,
            horizontalInset: 8,
            cornerRadius: 2,
            animationDuration: 0.3
        )
        .onTabChanged { newIndex in
            print("Selected tab: \(newIndex)")
        }
    }
}

/// Example demonstrating custom tab views with images and badges (Array 방식)
struct CustomTabViewsArraySample: View {
    @State private var selectedIndex = 0
    
    private var tabItems: [TabPagerItem] {
        [
            VStack {
                Spacer()
                Text("HOME")
                    .font(.largeTitle)
                Spacer()
            }
            .tabTitle {
                HStack(spacing: 4) {
                    Image(systemName: "house.fill")
                        .foregroundColor(selectedIndex == 0 ? .blue : .gray)
                    Text("home")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedIndex == 0 ? .blue : .gray)
                }
            },
            
            VStack {
                Spacer()
                Text("AlERT")
                    .font(.largeTitle)
                Spacer()
            }
            .tabTitle {
                HStack(spacing: 4) {
                    Image(systemName: "bell.fill")
                        .foregroundColor(selectedIndex == 1 ? .blue : .gray)
                    Text("alert")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedIndex == 1 ? .blue : .gray)
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                }
            },
            
            VStack {
                Spacer()
                Text("SETTING")
                    .font(.largeTitle)
                Spacer()
            }
            .tabTitle {
                HStack(spacing: 4) {
                    Image(systemName: "gear")
                        .foregroundColor(selectedIndex == 2 ? .blue : .gray)
                    Text("setting")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedIndex == 2 ? .blue : .gray)
                }
            }
        ]
    }
    
    var body: some View {
        TabPagerX(
            selectedIndex: $selectedIndex,
            items: tabItems
        )
        .tabBarLayoutStyle(.scrollable)
        .tabButtonStyle(
            normal: ButtonStateStyle(font: .body, textColor: .gray, backgroundColor: .white),
            selected: ButtonStateStyle(font: .headline, textColor: .blue, backgroundColor: .white),
            padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
            cornerRadius: 8
        )
        .tabIndicatorStyle(
            height: 3,
            color: .blue,
            horizontalInset: 8,
            cornerRadius: 2,
            animationDuration: 0.3
        )
        .onTabChanged { newIndex in
            print("Selected tab: \(newIndex)")
        }
    }
}

// MARK: - API 데이터 모델 예제
struct TabData: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let hasBadge: Bool
    let badgeColor: Color
}

/// Example demonstrating custom tab views with API data (API 방식)
struct APITabViewsSample: View {
    @State private var selectedIndex = 0
    @State private var tabData: [TabData] = []
    @State private var isLoading = true
    
    // API에서 받은 데이터를 시뮬레이션
    private func loadTabData() {
        // 실제로는 API 호출
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            tabData = [
                TabData(title: "Home", iconName: "house.fill", hasBadge: false, badgeColor: .red),
                TabData(title: "Message", iconName: "message.fill", hasBadge: true, badgeColor: .red),
                TabData(title: "Alert", iconName: "bell.fill", hasBadge: true, badgeColor: .orange),
                TabData(title: "Profile", iconName: "person.fill", hasBadge: false, badgeColor: .blue),
                TabData(title: "Setting", iconName: "gear", hasBadge: false, badgeColor: .gray)
            ]
            isLoading = false
        }
    }
    
    private var tabItems: [TabPagerItem] {
        tabData.enumerated().map { index, data in
            VStack {
                Spacer()
                Text("data: - \(data.title)")
                    .font(.largeTitle)
                Text("index: \(index)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            .tabTitle {
                HStack(spacing: 4) {
                    Image(systemName: data.iconName)
                        .foregroundColor(selectedIndex == index ? .blue : .gray)
                    Text(data.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedIndex == index ? .blue : .gray)
                    if data.hasBadge {
                        Circle()
                            .fill(data.badgeColor)
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if isLoading {
                VStack {
                    ProgressView()
                    Text("loading...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                TabPagerX(
                    selectedIndex: $selectedIndex,
                    items: tabItems
                )
                .tabBarLayoutStyle(.scrollable)
                .tabButtonStyle(
                    normal: ButtonStateStyle(font: .body, textColor: .gray, backgroundColor: .white),
                    selected: ButtonStateStyle(font: .headline, textColor: .blue, backgroundColor: .white),
                    padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
                    cornerRadius: 8
                )
                .tabIndicatorStyle(
                    height: 3,
                    color: .blue,
                    horizontalInset: 8,
                    cornerRadius: 2,
                    animationDuration: 0.3
                )
                .onTabChanged { newIndex in
                    print("Selected tab: \(newIndex)")
                }
            }
        }
        .onAppear {
            loadTabData()
        }
    }
}
