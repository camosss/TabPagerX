//
//  DeepLinkSample.swift
//  TabPagerXSample
//
//  CASE: Changing the tab from OUTSIDE the pager (deep links, buttons).
//
//  Because selection is a plain `Binding<Item.ID?>`, anything that can set that
//  state can drive the pager: a deep link handler, a push notification, or —
//  as shown here — buttons elsewhere on screen. Assign the id and the pager
//  animates to that tab; no index lookups.
//

import SwiftUI
import TabPagerX

struct DeepLinkSample: View {

    struct Section: Identifiable, Equatable {
        let id: String
        let title: String
        let color: Color
    }

    private let items = [
        Section(id: "news", title: "News", color: .red),
        Section(id: "sports", title: "Sports", color: .orange),
        Section(id: "tech", title: "Tech", color: .blue),
        Section(id: "event", title: "Event", color: .green)
    ]

    @State private var selection: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Deep Link / Programmatic",
                description: "The buttons below set the selection id directly, exactly like a deep link handler would."
            )

            // Simulated deep-link entry points. In a real app these ids would
            // come from a URL, a notification payload, etc.
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(items) { item in
                        Button {
                            // This is the whole deep-link mechanism: set the id.
                            withAnimation { selection = item.id }
                        } label: {
                            Text("Open \(item.title)")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(item.color.opacity(0.15))
                                .foregroundColor(item.color)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)

            TabPagerX(
                selection: $selection,
                items: items
            ) { item in
                DemoContentBlock(
                    title: item.title,
                    subtitle: "Jumped here via selection = \"\(item.id)\"",
                    color: item.color
                )
            } label: { item, state in
                Text(item.title)
                    .font(state.isSelected ? .headline : .body)
                    .foregroundColor(state.isSelected ? item.color : .secondary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
            }
            .tabBarLayoutStyle(.scrollable)
            .tabBarLayoutConfig(buttonSpacing: 6, sidePadding: 12)
            .tabIndicatorStyle(height: 3, color: .blue)
        }
        .navigationTitle("Deep Link")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationView { DeepLinkSample() }
}
#endif
