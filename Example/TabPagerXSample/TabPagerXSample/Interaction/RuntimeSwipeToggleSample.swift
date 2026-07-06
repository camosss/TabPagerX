//
//  RuntimeSwipeToggleSample.swift
//  TabPagerXSample
//
//  CASE: Toggling swipe on/off at runtime.
//
//  `.contentSwipeEnabled(_:)` reacts to state changes — you can flip it while
//  the pager is on screen. A common use is an "edit mode": lock paging so a
//  drag-to-reorder or drawing gesture inside a page doesn't get hijacked by the
//  pager, then unlock when editing ends.
//

import SwiftUI
import TabPagerX

struct RuntimeSwipeToggleSample: View {

    struct TabItem: Identifiable, Equatable {
        let id: String
        let title: String
    }

    private let items = [
        TabItem(id: "canvas", title: "Canvas"),
        TabItem(id: "layers", title: "Layers"),
        TabItem(id: "export", title: "Export")
    ]

    @State private var selection: String? = nil

    // Drives the swipe flag. Toggling this updates the live pager.
    @State private var isEditing = false

    var body: some View {
        VStack(spacing: 0) {
            CaseBanner(
                title: "Runtime Swipe Toggle",
                description: "Turn on Edit mode to lock paging while a page is being edited, then turn it off to restore swipe."
            )

            Toggle("Edit mode (locks paging)", isOn: $isEditing)
                .padding()

            TabPagerX(
                selection: $selection,
                items: items
            ) { item in
                VStack(spacing: 8) {
                    Text(item.title).font(.title)
                    Text(isEditing
                         ? "Editing — swipe is locked"
                         : "Not editing — swipe to change tabs")
                        .font(.caption)
                        .foregroundColor(isEditing ? .red : .secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            } label: { item, state in
                Text(item.title)
                    .font(state.isSelected ? .headline : .body)
                    .foregroundColor(state.isSelected ? .blue : .secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
            .tabBarLayoutStyle(.fixed)
            .tabIndicatorStyle(height: 3, color: .blue)
            // Flipped live by the toggle above. Note that even when swipe is
            // locked, tapping a tab still works — only the gesture is disabled.
            .contentSwipeEnabled(!isEditing)
        }
        .navigationTitle("Runtime Toggle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationView { RuntimeSwipeToggleSample() }
}
#endif
