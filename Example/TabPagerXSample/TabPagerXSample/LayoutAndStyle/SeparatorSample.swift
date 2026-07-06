//
//  SeparatorSample.swift
//  TabPagerXSample
//
//  CASE: Separator line between the tab bar and the content.
//
//  `.tabBarSeparator(...)` draws a hairline under the tab bar to visually
//  detach it from the page content. It's off by default; add the modifier to
//  turn it on. A Toggle here lets you compare on/off side by side.
//

import SwiftUI
import TabPagerX

struct SeparatorSample: View {

    struct TabItem: Identifiable, Equatable {
        let id: String
        let title: String
    }

    private let items = [
        TabItem(id: "feed", title: "Feed"),
        TabItem(id: "explore", title: "Explore"),
        TabItem(id: "alerts", title: "Alerts")
    ]

    @State private var selection: String? = nil
    @State private var showSeparator = true

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Separator",
                description: "A hairline between the tab bar and content. Off by default; the toggle shows the difference."
            )

            Toggle("Show separator", isOn: $showSeparator)
                .padding()

            TabPagerX(
                selection: $selection,
                items: items
            ) { item in
                DemoContentBlock(
                    title: item.title,
                    subtitle: "Notice the line above this content",
                    color: SamplePalette.color(items.firstIndex(of: item) ?? 0)
                )
            } label: { item, state in
                Text(item.title)
                    .font(state.isSelected ? .headline : .body)
                    .foregroundColor(state.isSelected ? .primary : .secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
            }
            .tabBarLayoutStyle(.fixed)
            .tabIndicatorStyle(height: 2, color: .blue)
            // `isHidden` lets you keep the modifier in place and toggle it,
            // rather than conditionally attaching/removing the modifier.
            .tabBarSeparator(
                color: .gray.opacity(0.3),
                height: 1,
                horizontalPadding: 0,
                isHidden: !showSeparator
            )
        }
        .navigationTitle("Separator")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationView { SeparatorSample() }
}
#endif
