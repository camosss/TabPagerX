//
//  SafeAreaSample.swift
//  TabPagerXSample
//
//  CASE: Safe area behavior (contentIgnoresSafeArea).
//
//  By DEFAULT (since 3.0) TabPagerX RESPECTS the safe area, so it sits cleanly
//  above a bottom tab bar / toolbar / home indicator with no extra work.
//
//  For full-screen content (media, maps, color washes that should bleed to the
//  bottom edge) opt in with `.contentIgnoresSafeArea(edges:)`. This restores the
//  pre-3.0 behavior, but now it's your choice per usage.
//

import SwiftUI
import TabPagerX

struct SafeAreaSample: View {

    struct TabItem: Identifiable, Equatable {
        let id: String
        let title: String
        let color: Color
    }

    private let items = [
        TabItem(id: "a", title: "A", color: .blue),
        TabItem(id: "b", title: "B", color: .green),
        TabItem(id: "c", title: "C", color: .orange)
    ]

    @State private var selection: String? = nil
    @State private var extendIntoSafeArea = false

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Safe Area",
                description: "Default respects the safe area. Toggle on to let content bleed into the bottom safe area."
            )

            Toggle("Extend into bottom safe area", isOn: $extendIntoSafeArea)
                .padding()

            pager
        }
        .navigationTitle("Safe Area")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Split out so we can attach the modifier conditionally while keeping the
    // pager configuration in one place.
    @ViewBuilder
    private var pager: some View {
        let base = TabPagerX(
            selection: $selection,
            items: items
        ) { item in
            // A full-bleed color makes the safe-area difference obvious:
            // with the toggle ON, the color reaches the very bottom of the screen.
            item.color.opacity(0.25)
                .overlay(
                    Text("Watch the bottom edge")
                        .font(.headline)
                        .foregroundColor(item.color)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        } label: { item, state in
            Text(item.title)
                .font(state.isSelected ? .headline : .body)
                .foregroundColor(state.isSelected ? item.color : .secondary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
        }
        .tabBarLayoutStyle(.fixed)
        .tabIndicatorStyle(height: 3, color: .blue)

        if extendIntoSafeArea {
            base.contentIgnoresSafeArea(edges: .bottom)
        } else {
            base
        }
    }
}

#if DEBUG
#Preview {
    NavigationView { SafeAreaSample() }
}
#endif
