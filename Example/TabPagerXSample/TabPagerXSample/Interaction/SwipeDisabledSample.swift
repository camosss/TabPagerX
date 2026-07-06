//
//  SwipeDisabledSample.swift
//  TabPagerXSample
//
//  CASE: Disabling swipe for instant tab switching.
//
//  `.contentSwipeEnabled(false)` does two things:
//    1. blocks the left/right swipe gesture between pages, and
//    2. removes the slide animation when you TAP a tab — content switches
//       instantly.
//
//  Use this when pages are heavy, or when a swipe would conflict with content
//  that itself scrolls horizontally (carousels, maps).
//

import SwiftUI
import TabPagerX

struct SwipeDisabledSample: View {

    struct TabItem: Identifiable, Equatable {
        let id: String
        let title: String
        let color: Color
    }

    private let items = [
        TabItem(id: "a", title: "Tab A", color: .red),
        TabItem(id: "b", title: "Tab B", color: .blue),
        TabItem(id: "c", title: "Tab C", color: .green)
    ]

    @State private var selection: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Swipe Disabled",
                description: "Swipe is off — tapping a tab switches instantly, with no slide animation."
            )

            TabPagerX(
                selection: $selection,
                items: items
            ) { item in
                VStack(spacing: 8) {
                    Text(item.title)
                        .font(.largeTitle.bold())
                        .foregroundColor(item.color)
                    Text("Try swiping — nothing happens. Tap a tab instead.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(item.color.opacity(0.1))

            } label: { item, state in
                Text(item.title)
                    .font(state.isSelected ? .headline : .body)
                    .foregroundColor(state.isSelected ? item.color : .secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
            .tabBarLayoutStyle(.fixed)
            .tabIndicatorStyle(height: 3, color: .red)
            // Swipe off → tap-only, instant switch.
            .contentSwipeEnabled(false)
        }
        .navigationTitle("Swipe Disabled")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationView { SwipeDisabledSample() }
}
#endif
