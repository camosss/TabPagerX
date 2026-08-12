//
//  SafeAreaSample.swift
//  SwiftUITabPagerSample
//
//  CASE: Safe area behavior.
//
//  By DEFAULT the pager FILLS the bottom safe area, so media, maps and colour
//  washes reach the bottom edge of the screen with no extra work.
//
//  When the pager sits above a bottom tab bar or toolbar and its content must
//  not run underneath, opt out with `.contentRespectsSafeArea()`.
//

import SwiftUI
import SwiftUITabPager

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
    @State private var respectSafeArea = false

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Safe Area",
                description: "Default fills the bottom safe area. Toggle on to keep the pager inside it instead."
            )

            Toggle("Respect the bottom safe area", isOn: $respectSafeArea)
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
        let base = TabPager(
            selection: $selection,
            items: items
        ) { item in
            // A full-bleed color makes the safe-area difference obvious:
            // with the toggle ON, the color stops above the home indicator.
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

        if respectSafeArea {
            base.contentRespectsSafeArea()
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
