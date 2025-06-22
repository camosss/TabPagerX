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
