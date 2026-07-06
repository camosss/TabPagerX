//
//  IndicatorStyleSample.swift
//  TabPagerXSample
//
//  CASE: Customizing the indicator (the moving underline).
//
//  `.tabIndicatorStyle(...)` controls the bar that slides under the selected tab.
//  Every parameter is optional — pass only what you want to change:
//    - height            : thickness of the bar
//    - color             : fill color
//    - horizontalInset   : shrink the bar in from each side of the tab
//    - cornerRadius      : round the bar into a pill
//    - animationDuration : how long the tap-to-tab slide takes
//
//  This case exposes sliders so you can feel each parameter. During a swipe the
//  indicator tracks your finger regardless of these values.
//

import SwiftUI
import TabPagerX

struct IndicatorStyleSample: View {

    struct TabItem: Identifiable, Equatable {
        let id: String
        let title: String
    }

    private let items = [
        TabItem(id: "one", title: "One"),
        TabItem(id: "two", title: "Two"),
        TabItem(id: "three", title: "Three")
    ]

    @State private var selection: String? = nil

    // Live-tunable indicator parameters.
    @State private var height: CGFloat = 4
    @State private var inset: CGFloat = 12
    @State private var cornerRadius: CGFloat = 2

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Indicator Customization",
                description: "Tune height, inset and corner radius live. Only the parameters you pass are overridden."
            )

            controls

            TabPagerX(
                selection: $selection,
                items: items
            ) { item in
                Text("Content for \(item.title)")
                    .font(.title2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            } label: { item, state in
                Text(item.title)
                    .font(state.isSelected ? .headline : .body)
                    .foregroundColor(state.isSelected ? .orange : .secondary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
            .tabBarLayoutStyle(.fixed)
            // Rebuilt whenever a slider changes, so edits apply immediately.
            .tabIndicatorStyle(
                height: height,
                color: .orange,
                horizontalInset: inset,
                cornerRadius: cornerRadius,
                animationDuration: 0.25
            )
        }
        .navigationTitle("Indicator Style")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: 8) {
            slider("Height", value: $height, range: 1...12)
            slider("Inset", value: $inset, range: 0...40)
            slider("Corner", value: $cornerRadius, range: 0...6)
        }
        .padding()
    }

    private func slider(_ title: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>) -> some View {
        HStack {
            Text(title)
                .font(.caption)
                .frame(width: 56, alignment: .leading)
            Slider(value: value, in: range)
            Text(String(format: "%.0f", value.wrappedValue))
                .font(.caption.monospacedDigit())
                .frame(width: 28, alignment: .trailing)
        }
    }
}

#if DEBUG
#Preview {
    NavigationView { IndicatorStyleSample() }
}
#endif
