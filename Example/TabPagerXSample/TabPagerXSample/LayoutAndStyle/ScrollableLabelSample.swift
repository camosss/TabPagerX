//
//  ScrollableLabelSample.swift
//  TabPagerXSample
//
//  CASE: Real-time label effects with TabState.selectionProgress.
//
//  The second argument of the `label` closure is a `TabState`:
//    - state.isSelected         → Bool, flips at the swipe midpoint
//    - state.selectionProgress  → CGFloat 0...1, interpolates in REAL TIME
//                                 as your finger drags between pages
//
//  Use `selectionProgress` to drive continuous effects (color, opacity, scale)
//  so the label smoothly "activates" as you swipe, instead of snapping.
//

import SwiftUI
import TabPagerX

struct ScrollableLabelSample: View {

    struct CategoryItem: Identifiable, Equatable {
        let id: String
        let title: String
        let emoji: String
        let color: Color
    }

    private let items = [
        CategoryItem(id: "all", title: "All", emoji: "🌐", color: .blue),
        CategoryItem(id: "music", title: "Music", emoji: "🎵", color: .pink),
        CategoryItem(id: "sports", title: "Sports", emoji: "⚽", color: .green),
        CategoryItem(id: "gaming", title: "Gaming", emoji: "🎮", color: .purple),
        CategoryItem(id: "food", title: "Food", emoji: "🍕", color: .orange),
        CategoryItem(id: "travel", title: "Travel", emoji: "✈️", color: .cyan)
    ]

    @State private var selection: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Real-time Label",
                description: "Swipe slowly: the label color and scale interpolate with selectionProgress, tracking your finger."
            )

            TabPagerX(
                selection: $selection,
                items: items
            ) { item in
                VStack(spacing: 16) {
                    Text(item.emoji).font(.system(size: 80))
                    Text(item.title).font(.title).foregroundColor(item.color)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(item.color.opacity(0.05))

            } label: { item, state in
                // `selectionProgress` is 0 when this tab is fully unselected and
                // 1 when fully selected. Mid-swipe it's a fraction, so both the
                // color and the scale move continuously as you drag.
                Text("\(item.emoji) \(item.title)")
                    .font(.subheadline)
                    .foregroundColor(
                        item.color.opacity(0.35 + 0.65 * state.selectionProgress)
                    )
                    .scaleEffect(1 + 0.10 * state.selectionProgress)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
            }
            .tabBarLayoutStyle(.scrollable)
            .tabBarLayoutConfig(buttonSpacing: 6, sidePadding: 12)
            .tabIndicatorStyle(height: 3, color: .blue, cornerRadius: 1.5)
        }
        .navigationTitle("Real-time Label")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationView { ScrollableLabelSample() }
}
#endif
