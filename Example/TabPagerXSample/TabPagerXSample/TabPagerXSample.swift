import SwiftUI
import TabPagerX

struct TabPagerXSampleHome: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("1. Same Content", destination: SameViewSample())
                NavigationLink("2. Different Views by Type", destination: DifferentViewSample())
            }
            .navigationTitle("TabPagerX Samples")
        }
    }
}

/// Case 1: `Same View`
/// - All items use the same view structure
struct SameViewSample: View {

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

// MARK: - Data Models

struct TabItem: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let color: Color
}

enum TabItemType {
    case text(String)
    case image(String)
    case custom
}

struct MixedTabItem: Identifiable {
    let id = UUID()
    let type: TabItemType
    let title: String
}
