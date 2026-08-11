//
//  LayoutStyleSample.swift
//  SwiftUITabPagerSample
//
//  CASE: Fixed vs Scrollable tab bar.
//
//  `.tabBarLayoutStyle(_:)` picks how the tab bar sizes its buttons:
//   - .fixed      → tabs split the screen width equally (best for a few tabs)
//   - .scrollable → tabs size to their content and scroll horizontally
//                   (best for many tabs)
//  This case lets you flip between them live with a Picker so the difference
//  is obvious.
//

import SwiftUI
import SwiftUITabPager

struct LayoutStyleSample: View {

    struct TabItem: Identifiable, Equatable {
        let id: String
        let title: String
    }

    // Each style gets the item count it is designed for:
    //  - .fixed      → a few tabs, so equal-width buttons keep labels on one line
    //  - .scrollable → a longer list, so there is actually something to scroll
    private let fixedItems: [TabItem] = [
        "All", "Music", "Food", "Art"
    ].map { TabItem(id: $0.lowercased(), title: $0) }

    private let scrollableItems: [TabItem] = [
        "All", "Music", "Sports", "Gaming", "Food", "Travel", "Science", "Art"
    ].map { TabItem(id: $0.lowercased(), title: $0) }

    private var items: [TabItem] {
        useScrollable ? scrollableItems : fixedItems
    }

    @State private var selection: String? = nil
    @State private var useScrollable = false

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Fixed vs Scrollable",
                description: "Toggle the layout style. Fixed splits the width equally; scrollable sizes to content and scrolls."
            )

            Picker("Layout", selection: $useScrollable) {
                Text("Fixed").tag(false)
                Text("Scrollable").tag(true)
            }
            .pickerStyle(.segmented)
            .padding()

            TabPager(
                selection: $selection,
                items: items
            ) { item in
                DemoContentBlock(
                    title: item.title,
                    subtitle: "Layout: \(useScrollable ? "scrollable" : "fixed")",
                    color: SamplePalette.color(items.firstIndex(of: item) ?? 0)
                )
            } label: { item, state in
                Text(item.title)
                    .font(state.isSelected ? .headline : .body)
                    .foregroundColor(state.isSelected ? .blue : .secondary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
            }
            // The whole point of this case: switch the style at runtime.
            .tabBarLayoutStyle(useScrollable ? .scrollable : .fixed)
            // In scrollable mode, spacing + side padding keep the tabs from
            // touching each other and the screen edges.
            .tabBarLayoutConfig(buttonSpacing: 4, sidePadding: 12)
            .tabIndicatorStyle(height: 3, color: .blue, cornerRadius: 1.5)
        }
        .navigationTitle("Layout Style")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationView { LayoutStyleSample() }
}
#endif
