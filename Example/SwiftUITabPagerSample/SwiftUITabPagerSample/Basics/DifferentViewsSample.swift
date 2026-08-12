//
//  DifferentViewsSample.swift
//  SwiftUITabPagerSample
//
//  CASE: A different view per tab type.
//
//  When each tab needs genuinely different UI, switch on the item inside the
//  `content` closure. Because `content` is a normal @ViewBuilder, you can return
//  completely different view trees per item — plain text, a List, a grid, a
//  custom shape. Scrollable containers keep their own vertical scrolling while
//  the pager keeps the horizontal swipe.
//

import SwiftUI
import SwiftUITabPager

struct DifferentViewsSample: View {

    struct MixedItem: Identifiable, Equatable {
        let id: String
        let title: String
        let kind: Kind

        // Model the "what to show" as data on the item, then switch on it.
        enum Kind: Equatable {
            case text(String)
            case list
            case grid
            case gradient
        }
    }

    private let items = [
        MixedItem(id: "text", title: "Text", kind: .text("Hello, TabPager")),
        MixedItem(id: "list", title: "List", kind: .list),
        MixedItem(id: "grid", title: "Grid", kind: .grid),
        MixedItem(id: "custom", title: "Custom", kind: .gradient)
    ]

    @State private var selection: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Different Views by Type",
                description: "Switch on the item inside `content` to return a different view tree per tab."
            )

            TabPager(
                selection: $selection,
                items: items
            ) { item in
                // Each case returns a different view — the pager doesn't care
                // what the content looks like, only that it's a View.
                switch item.kind {
                case .text(let string):
                    Text(string)
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.blue.opacity(0.08))

                case .list:
                    listPage

                case .grid:
                    gridPage

                case .gradient:
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.purple.opacity(0.08))
                }

            } label: { item, state in
                // The label can also branch on the item — here we prepend a
                // small icon for non-text tabs.
                HStack(spacing: 4) {
                    switch item.kind {
                    case .text: EmptyView()
                    case .list: Image(systemName: "list.bullet").font(.caption)
                    case .grid: Image(systemName: "square.grid.2x2").font(.caption)
                    case .gradient: Image(systemName: "paintpalette").font(.caption)
                    }
                    Text(item.title)
                }
                // Four tabs in a fixed bar leave little room per tab, so keep the
                // label on one line and let it shrink instead of wrapping.
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .font(state.isSelected ? .subheadline.bold() : .subheadline)
                .foregroundColor(state.isSelected ? .purple : .secondary)
                .padding(.horizontal, 6)
                .padding(.vertical, 8)
            }
            .tabBarLayoutStyle(.fixed)
            .tabIndicatorStyle(height: 4, color: .purple)
        }
        .navigationTitle("Different Views")
        .navigationBarTitleDisplayMode(.inline)
    }

    // A native List keeps its own vertical scrolling inside the page, and its
    // rows stay tappable while a horizontal swipe still changes tabs.
    private var listPage: some View {
        List {
            Section("Inbox") {
                ForEach(0..<12, id: \.self) { row in
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.purple)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Message \(row + 1)")
                            Text("Tap a row, swipe to change tabs")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    // A lazy grid, to show the page can host any scrollable container.
    private var gridPage: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3),
                spacing: 12
            ) {
                ForEach(0..<18, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(SamplePalette.color(index).opacity(0.25))
                        .frame(height: 90)
                        .overlay(
                            Text("\(index + 1)")
                                .font(.headline)
                                .foregroundColor(SamplePalette.color(index))
                        )
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}

#if DEBUG
#Preview {
    NavigationView { DifferentViewsSample() }
}
#endif
