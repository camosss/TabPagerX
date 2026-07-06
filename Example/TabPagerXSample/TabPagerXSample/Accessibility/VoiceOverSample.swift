//
//  VoiceOverSample.swift
//  TabPagerXSample
//
//  CASE: VoiceOver / accessibility.
//
//  TabPagerX renders each tab as a real Button, so VoiceOver treats them as
//  buttons out of the box:
//    - the currently selected tab carries the `.isSelected` trait
//      (VoiceOver announces "selected"), and
//    - each tab exposes its position as an accessibility value ("1 of 4").
//
//  You don't need any extra code for that. What you SHOULD do is make your
//  label's text meaningful — if a tab is icon-only, add an accessibility label
//  so VoiceOver has something to read. This case shows both.
//
//  To try it: enable VoiceOver (Settings ▸ Accessibility ▸ VoiceOver, or the
//  Accessibility Inspector on the Simulator) and swipe across the tabs.
//

import SwiftUI
import TabPagerX

struct VoiceOverSample: View {

    struct TabItem: Identifiable, Equatable {
        let id: String
        let title: String
        let icon: String
    }

    private let items = [
        TabItem(id: "home", title: "Home", icon: "house.fill"),
        TabItem(id: "favorites", title: "Favorites", icon: "heart.fill"),
        TabItem(id: "alerts", title: "Alerts", icon: "bell.fill"),
        TabItem(id: "you", title: "You", icon: "person.fill")
    ]

    @State private var selection: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "VoiceOver",
                description: "Tabs are real buttons: the selected one announces \"selected\" and each reports its position. Icon-only tabs get an explicit label."
            )

            TabPagerX(
                selection: $selection,
                items: items
            ) { item in
                VStack(spacing: 12) {
                    Image(systemName: item.icon).font(.system(size: 64))
                    Text(item.title).font(.title2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            } label: { item, state in
                // This tab is intentionally ICON-ONLY. Sighted users see the
                // symbol; VoiceOver would otherwise read the raw SF Symbol name.
                // Adding `.accessibilityLabel` gives it a proper spoken name.
                // (The selected/position traits are added by TabPagerX itself.)
                Image(systemName: item.icon)
                    .font(.title3)
                    .foregroundColor(state.isSelected ? .blue : .secondary)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .accessibilityLabel(item.title)
            }
            .tabBarLayoutStyle(.fixed)
            .tabIndicatorStyle(height: 3, color: .blue)
        }
        .navigationTitle("VoiceOver")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationView { VoiceOverSample() }
}
#endif
