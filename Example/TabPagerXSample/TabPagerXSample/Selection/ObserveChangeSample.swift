//
//  ObserveChangeSample.swift
//  TabPagerXSample
//
//  CASE: Reacting to tab changes.
//
//  Two complementary ways to observe changes:
//    1. `.onTabChanged { index in ... }` — a callback with the new INDEX.
//       Handy for analytics ("viewed tab 2").
//    2. `.onChange(of: selection)` — react to the selected item's ID.
//       Handy when you care about *which item*, not its position.
//
//  This case logs both into an on-screen history so you can see them fire.
//

import SwiftUI
import TabPagerX

struct ObserveChangeSample: View {

    struct TabItem: Identifiable, Equatable {
        let id: String
        let title: String
    }

    private let items = [
        TabItem(id: "overview", title: "Overview"),
        TabItem(id: "activity", title: "Activity"),
        TabItem(id: "billing", title: "Billing")
    ]

    @State private var selection: String? = nil
    @State private var log: [String] = []

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Observe Tab Changes",
                description: "onTabChanged gives the index; onChange(of: selection) gives the item id. Swipe or tap to see both."
            )

            TabPagerX(
                selection: $selection,
                items: items
            ) { item in
                Text(item.title)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            } label: { item, state in
                Text(item.title)
                    .font(state.isSelected ? .headline : .body)
                    .foregroundColor(state.isSelected ? .blue : .secondary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
            }
            .tabBarLayoutStyle(.fixed)
            .tabIndicatorStyle(height: 3, color: .blue)
            // (1) Index callback — fires on tap AND on swipe completion.
            .onTabChanged { index in
                append("onTabChanged → index \(index)")
            }
            // (2) Selection binding — observe the id itself.
            .onChange(of: selection) { newValue in
                append("selection → \(newValue ?? "nil")")
            }

            history
        }
        .navigationTitle("Observe Changes")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var history: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Event log")
                .font(.caption.bold())
                .foregroundColor(.secondary)
            // Show the most recent events first, capped so it stays readable.
            ForEach(log.suffix(6).reversed(), id: \.self) { line in
                Text(line)
                    .font(.caption2.monospaced())
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .padding()
        .background(Color(.secondarySystemBackground))
    }

    private func append(_ line: String) {
        log.append(line)
    }
}

#if DEBUG
#Preview {
    NavigationView { ObserveChangeSample() }
}
#endif
