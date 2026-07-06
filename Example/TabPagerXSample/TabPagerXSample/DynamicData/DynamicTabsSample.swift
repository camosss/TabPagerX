//
//  DynamicTabsSample.swift
//  TabPagerXSample
//
//  CASE: Async / server-driven tabs.
//
//  TabPagerX is safe with an empty `items` array — no `isLoading` guard needed.
//  Start empty, kick off a fetch, and assign `items` when it returns. The pager
//  renders the tabs and auto-selects the first one (or a preset id) the moment
//  data arrives.
//

import SwiftUI
import TabPagerX

struct DynamicTabsSample: View {

    struct FeedTab: Identifiable, Equatable {
        let id: String
        let title: String
        let icon: String
        let color: Color
    }

    @State private var selection: String? = nil
    @State private var items: [FeedTab] = []   // starts EMPTY — this is fine
    @State private var isLoading = false
    @State private var loadCount = 0

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Dynamic / Async Tabs",
                description: "Items start empty and arrive after a simulated network call. No loading guard around the pager."
            )

            HStack {
                Text(items.isEmpty ? "No tabs yet" : "\(items.count) tabs · load #\(loadCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button("Reload") { load() }
                    .font(.caption)
                    .disabled(isLoading)
            }
            .padding()

            ZStack {
                // The pager itself needs no `if isLoading` wrapper — it simply
                // shows an empty area until items exist. We only overlay a
                // spinner here for nicer UX.
                TabPagerX(
                    selection: $selection,
                    items: items
                ) { item in
                    DemoContentBlock(
                        title: item.title,
                        subtitle: "Loaded from the fake API",
                        color: item.color
                    )
                } label: { item, state in
                    HStack(spacing: 4) {
                        Image(systemName: item.icon).font(.caption)
                        Text(item.title)
                    }
                    .font(state.isSelected ? .headline : .body)
                    .foregroundColor(state.isSelected ? item.color : .secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                }
                .tabBarLayoutStyle(.scrollable)
                .tabBarLayoutConfig(buttonSpacing: 6, sidePadding: 12)
                .tabIndicatorStyle(height: 3, color: .green, horizontalInset: 8)

                if isLoading {
                    ProgressView()
                }
            }
        }
        .navigationTitle("Dynamic Tabs")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { if items.isEmpty { load() } }
    }

    // Simulates a network call that replaces the tab set after a short delay.
    private func load() {
        isLoading = true
        loadCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            items = [
                FeedTab(id: "news", title: "News", icon: "newspaper", color: .red),
                FeedTab(id: "sports", title: "Sports", icon: "sportscourt", color: .orange),
                FeedTab(id: "tech", title: "Tech", icon: "laptopcomputer", color: .blue),
                FeedTab(id: "weather", title: "Weather", icon: "cloud.sun", color: .cyan),
                FeedTab(id: "finance", title: "Finance", icon: "chart.line.uptrend.xyaxis", color: .green)
            ]
            isLoading = false
        }
    }
}

#if DEBUG
#Preview {
    NavigationView { DynamicTabsSample() }
}
#endif
