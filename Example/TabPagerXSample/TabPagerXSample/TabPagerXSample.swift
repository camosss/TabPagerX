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
                NavigationLink("4. Dynamic Tabs Add/Remove", destination: DynamicTabsSample())
            }
            .navigationTitle("TabPagerX Samples")
        }
    }
}

/// Example demonstrating fixed-width tab layout
struct FixedTabSample: View {
    @State private var tabs = ["One", "Two", "Three"]
    @State private var selectedIndex = 0

    var body: some View {
        TabPagerX(tabs: $tabs, selectedIndex: $selectedIndex) { index in
            VStack {
                Spacer()
                Text("Tab \(tabs[index])")
                    .font(.largeTitle)
                Spacer()
            }
        }
        .tabBarLayoutStyle(.fixed)
        .onTabChanged { newIndex in
            print("Selected tab: \(newIndex)")
        }
    }
}

/// Example demonstrating fixed-width tab layout with List content
struct FixedTabWithListSample: View {
    @State private var tabs = ["First", "Second", "Third"]
    @State private var selectedIndex = 0

    var body: some View {
        TabPagerX(tabs: $tabs, selectedIndex: $selectedIndex) { index in
            List(0..<20) { item in
                Text("Item \(item) in \(tabs[index])")
                    .padding()
            }
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .tabBarLayoutStyle(.fixed)
        .onTabChanged { newIndex in
            print("Selected tab: \(newIndex)")
        }
    }
}

/// Example demonstrating a scrollable tab bar
struct BasicScrollableTabSample: View {
    @State private var tabs = ["Home", "Profile", "Settings"]
    @State private var selectedIndex = 0

    var body: some View {
        TabPagerX(tabs: $tabs, selectedIndex: $selectedIndex) { index in
            Text("Content for \(tabs[index])")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
        }
        .tabBarLayoutStyle(.scrollable)
        .tabButtonStyle(
            normal: ButtonStateStyle(font: .body, textColor: .gray, backgroundColor: .white),
            selected: ButtonStateStyle(font: .headline, textColor: .blue, backgroundColor: .white),
            padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
            cornerRadius: 8,
            indicatorStyle: TabIndicatorStyle(
                height: 2,
                color: .blue,
                horizontalInset: 8,
                cornerRadius: 4,
                animationDuration: 0.25
            )
        )
        .onTabChanged { newIndex in
            print("Selected tab: \(newIndex)")
        }
    }
}

/// Example demonstrating dynamic tab addition and removal
struct DynamicTabsSample: View {
    @State private var tabs = ["Tab 1", "Tab 2"]
    @State private var selectedIndex = 0

    var body: some View {
        VStack {
            TabPagerX(tabs: $tabs, selectedIndex: $selectedIndex) { index in
                Text("Content: \(tabs[index])")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .tabBarLayoutStyle(.scrollable)
            .tabButtonStyle(
                normal: ButtonStateStyle(font: .body, textColor: .gray, backgroundColor: .white),
                selected: ButtonStateStyle(font: .headline, textColor: .blue, backgroundColor: .white),
                padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
                cornerRadius: 8,
                indicatorStyle: TabIndicatorStyle(
                    height: 2,
                    color: .blue,
                    horizontalInset: 8,
                    cornerRadius: 4,
                    animationDuration: 0.25
                )
            )
            .onTabChanged { newIndex in
                print("Selected tab: \(newIndex)")
            }

            HStack {
                Button("Add Tab") {
                    tabs.append("Tab \(tabs.count + 1)")
                }
                .padding()

                Button("Remove Tab") {
                    if !tabs.isEmpty {
                        tabs.removeLast()
                    }
                }
                .padding()
            }
        }
    }
}
