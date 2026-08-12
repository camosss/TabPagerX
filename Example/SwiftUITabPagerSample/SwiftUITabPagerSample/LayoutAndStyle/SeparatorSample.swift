//
//  SeparatorSample.swift
//  SwiftUITabPagerSample
//
//  CASE: Separator line between the tab bar and the content.
//
//  `.tabBarSeparator(...)` draws a hairline under the tab bar to visually
//  detach it from the page content. It's off by default; add the modifier to
//  turn it on. Every parameter is tunable here so you can feel what each does:
//    - color             : line color
//    - height            : line thickness
//    - horizontalPadding : inset from both screen edges
//    - isHidden          : keep the modifier attached and toggle it instead
//

import SwiftUI
import SwiftUITabPager

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

    private let palette: [(name: String, color: Color)] = [
        ("Gray", .gray.opacity(0.3)),
        ("Blue", .blue),
        ("Orange", .orange),
        ("Black", .black)
    ]

    @State private var selection: String? = nil
    @State private var showSeparator = true

    // Live-tunable separator parameters.
    @State private var height: CGFloat = 1
    @State private var horizontalPadding: CGFloat = 0
    @State private var colorIndex = 0

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Separator",
                description: "A hairline between the tab bar and content. Tune color, thickness and side padding live."
            )

            controls

            TabPager(
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
            // Rebuilt whenever a control changes, so edits apply immediately.
            // `isHidden` lets you keep the modifier in place and toggle it,
            // rather than conditionally attaching/removing the modifier.
            .tabBarSeparator(
                color: palette[colorIndex].color,
                height: height,
                horizontalPadding: horizontalPadding,
                isHidden: !showSeparator
            )
        }
        .navigationTitle("Separator")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle("Show separator", isOn: $showSeparator)
                .font(.caption)

            slider("Height", value: $height, range: 0.5...8, format: "%.1f")
            slider("Padding", value: $horizontalPadding, range: 0...60, format: "%.0f")

            HStack(spacing: 8) {
                Text("Color")
                    .font(.caption)
                    .frame(width: 56, alignment: .leading)

                ForEach(palette.indices, id: \.self) { index in
                    Button {
                        colorIndex = index
                    } label: {
                        Circle()
                            .fill(palette[index].color)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle().stroke(.blue, lineWidth: colorIndex == index ? 2 : 0)
                            )
                            .padding(2)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(palette[index].name)
                }
                Spacer()
            }
        }
        .padding()
    }

    private func slider(
        _ title: String,
        value: Binding<CGFloat>,
        range: ClosedRange<CGFloat>,
        format: String
    ) -> some View {
        HStack {
            Text(title)
                .font(.caption)
                .frame(width: 56, alignment: .leading)
            Slider(value: value, in: range)
            Text(String(format: format, value.wrappedValue))
                .font(.caption.monospacedDigit())
                .frame(width: 32, alignment: .trailing)
        }
    }
}

#if DEBUG
#Preview {
    NavigationView { SeparatorSample() }
}
#endif
