//
//  StatePreservationSample.swift
//  TabPagerXSample
//
//  CASE: Per-tab state survives item updates (id-based page cache).
//
//  TabPagerX caches each page by its item id. So when the items array changes:
//    - APPEND a tab   → existing tabs keep their scroll position and state
//    - REORDER tabs   → each page moves with its id, state intact
//    - REMOVE a tab   → only that page is dropped; the rest are untouched
//
//  This is why STABLE ids matter. To feel it: scroll a page down, then append
//  or shuffle tabs — the page you scrolled stays exactly where you left it.
//

import SwiftUI
import TabPagerX

struct StatePreservationSample: View {

    struct TabItem: Identifiable, Equatable {
        let id: String
        let title: String
    }

    @State private var items: [TabItem] = [
        TabItem(id: "alpha", title: "Alpha"),
        TabItem(id: "bravo", title: "Bravo"),
        TabItem(id: "charlie", title: "Charlie")
    ]

    @State private var selection: String? = nil
    @State private var nextTab = 0

    private let extraTitles = ["Delta", "Echo", "Foxtrot", "Golf"]

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "State Preservation",
                description: "Scroll a page down, then Append or Shuffle. Existing pages keep their scroll position because pages are cached by id."
            )

            HStack(spacing: 8) {
                Button("Append") { append() }
                Button("Shuffle") { shuffle() }
                Button("Remove last") { removeLast() }
                    .disabled(items.count <= 1)
            }
            .font(.caption)
            .padding()

            TabPagerX(
                selection: $selection,
                items: items
            ) { item in
                // DemoContentBlock is scrollable, so each tab has real scroll
                // state that we can watch survive across item changes.
                DemoContentBlock(
                    title: item.title,
                    subtitle: "Scroll me, then append / shuffle the tabs",
                    color: SamplePalette.color(abs(item.id.hashValue))
                )
            } label: { item, state in
                Text(item.title)
                    .font(state.isSelected ? .headline : .body)
                    .foregroundColor(state.isSelected ? .blue : .secondary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
            }
            .tabBarLayoutStyle(.scrollable)
            .tabBarLayoutConfig(buttonSpacing: 6, sidePadding: 12)
            .tabIndicatorStyle(height: 3, color: .blue)
        }
        .navigationTitle("State Preservation")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Adds a new tab at the end. Existing pages are untouched — their id is
    // still in the array, so their cached page (and scroll offset) is kept.
    private func append() {
        guard nextTab < extraTitles.count else { return }
        let title = extraTitles[nextTab]
        nextTab += 1
        items.append(TabItem(id: title.lowercased(), title: title))
    }

    // Reorders the same items. Because the cache is keyed by id, each page
    // follows its item to the new position with state intact.
    private func shuffle() {
        items.shuffle()
    }

    private func removeLast() {
        items.removeLast()
    }
}

#if DEBUG
#Preview {
    NavigationView { StatePreservationSample() }
}
#endif
