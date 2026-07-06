//
//  SameContentSample.swift
//  TabPagerXSample
//
//  CASE: Same content shape for every tab.
//
//  The simplest possible usage — every tab renders the *same* view structure,
//  just with different data. This is the "hello world" of TabPagerX.
//

import SwiftUI
import TabPagerX

struct SameContentSample: View {

    // MARK: Data model
    //
    // Items must be `Identifiable & Equatable`.
    //
    // ⚠️ Use a STABLE id that comes from your data (here a constant string).
    //    Do NOT write `let id = UUID()` — a fresh UUID on every render makes
    //    every update look like a brand-new set of tabs, which throws away
    //    selection and per-tab state. A stable id is what lets TabPagerX keep
    //    the selected tab and preserve each page across updates.
    struct TabItem: Identifiable, Equatable {
        let id: String
        let title: String
        let body: String
    }

    private let items = [
        TabItem(id: "home", title: "Home", body: "Welcome to Home"),
        TabItem(id: "search", title: "Search", body: "Search content"),
        TabItem(id: "profile", title: "Profile", body: "Profile content")
    ]

    // MARK: Selection
    //
    // Bind an optional item id. `nil` means "nothing selected yet"; once items
    // are present, TabPagerX selects the first one automatically. You can read
    // this value at any time to know which tab is showing.
    @State private var selection: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Same Content",
                description: "Every tab uses the same view shape with different data. Bind selection to an optional item id."
            )

            TabPagerX(
                selection: $selection,
                items: items
            ) { item in
                // `content` builds the page body for one item.
                // Same layout for all three tabs, only the data differs.
                VStack(spacing: 12) {
                    Text(item.body)
                        .font(.title2)
                    Text("id: \(item.id)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            } label: { item, state in
                // `label` builds the tab button for one item.
                // `state.isSelected` flips as the selected tab changes (and
                // follows the swipe once it passes the halfway point).
                Text(item.title)
                    .font(state.isSelected ? .headline : .body)
                    .foregroundColor(state.isSelected ? .blue : .secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
            // Equal-width tabs across the screen (this is the default).
            .tabBarLayoutStyle(.fixed)
            // A thin underline that slides under the selected tab.
            .tabIndicatorStyle(height: 3, color: .blue, horizontalInset: 16)
        }
        .navigationTitle("Same Content")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationView { SameContentSample() }
}
#endif
