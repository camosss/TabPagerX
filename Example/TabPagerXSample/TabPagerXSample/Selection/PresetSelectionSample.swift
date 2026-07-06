//
//  PresetSelectionSample.swift
//  TabPagerXSample
//
//  CASE: Starting on a specific tab (replaces the old `initialIndex`).
//
//  Just give the `selection` binding a non-nil starting id. When items load,
//  TabPagerX honors that id if it exists (otherwise it falls back to the first
//  tab). No index math, and it keeps working even if the server reorders tabs.
//

import SwiftUI
import TabPagerX

struct PresetSelectionSample: View {

    struct TabItem: Identifiable, Equatable {
        let id: String
        let title: String
        let color: Color
    }

    private let items = [
        TabItem(id: "home", title: "Home", color: .blue),
        TabItem(id: "search", title: "Search", color: .green),
        TabItem(id: "profile", title: "Profile", color: .orange),
        TabItem(id: "settings", title: "Settings", color: .purple)
    ]

    // Start on "profile" — the 3rd tab — without knowing it's index 2.
    // If the tabs were reordered, this still opens Profile.
    @State private var selection: String? = "profile"

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Preset Selection",
                description: "selection starts as \"profile\", so the pager opens on that tab regardless of its position."
            )

            Text("Current selection: \(selection ?? "nil")")
                .font(.caption.monospaced())
                .foregroundColor(.secondary)
                .padding(.vertical, 8)

            TabPagerX(
                selection: $selection,
                items: items
            ) { item in
                DemoContentBlock(
                    title: item.title,
                    subtitle: "id: \(item.id)",
                    color: item.color
                )
            } label: { item, state in
                Text(item.title)
                    .font(state.isSelected ? .headline : .body)
                    .foregroundColor(state.isSelected ? item.color : .secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
            }
            // Scrollable so a preset tab that's off-screen scrolls into view
            // automatically on first appearance.
            .tabBarLayoutStyle(.scrollable)
            .tabBarLayoutConfig(buttonSpacing: 6, sidePadding: 12)
            .tabIndicatorStyle(height: 3, color: .blue, horizontalInset: 8)
        }
        .navigationTitle("Preset Selection")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationView { PresetSelectionSample() }
}
#endif
