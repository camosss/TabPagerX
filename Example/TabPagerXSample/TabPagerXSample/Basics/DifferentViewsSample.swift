//
//  DifferentViewsSample.swift
//  TabPagerXSample
//
//  CASE: A different view per tab type.
//
//  When each tab needs genuinely different UI, switch on the item inside the
//  `content` closure. Because `content` is a normal @ViewBuilder, you can return
//  completely different view trees per item — text, image, custom shapes, etc.
//

import SwiftUI
import TabPagerX

struct DifferentViewsSample: View {

    struct MixedItem: Identifiable, Equatable {
        let id: String
        let title: String
        let kind: Kind

        // Model the "what to show" as data on the item, then switch on it.
        enum Kind: Equatable {
            case text(String)
            case symbol(String)
            case gradient
        }
    }

    private let items = [
        MixedItem(id: "text", title: "Text", kind: .text("Hello, TabPagerX")),
        MixedItem(id: "image", title: "Image", kind: .symbol("star.fill")),
        MixedItem(id: "custom", title: "Custom", kind: .gradient)
    ]

    @State private var selection: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Different Views by Type",
                description: "Switch on the item inside `content` to return a different view tree per tab."
            )

            TabPagerX(
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

                case .symbol(let name):
                    Image(systemName: name)
                        .font(.system(size: 80))
                        .foregroundColor(.yellow)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.yellow.opacity(0.08))

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
                    case .symbol: Image(systemName: "photo").font(.caption)
                    case .gradient: Image(systemName: "paintpalette").font(.caption)
                    }
                    Text(item.title)
                }
                .font(state.isSelected ? .headline : .body)
                .foregroundColor(state.isSelected ? .purple : .secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            .tabBarLayoutStyle(.fixed)
            .tabIndicatorStyle(height: 4, color: .purple)
        }
        .navigationTitle("Different Views")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationView { DifferentViewsSample() }
}
#endif
