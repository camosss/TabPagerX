//
//  SampleHomeView.swift
//  TabPagerXSample
//
//  Catalog of TabPagerX usage cases, grouped by topic.
//  Each row navigates to a self-contained case file under the matching folder —
//  open any one of them to read a focused, heavily commented example.
//

import SwiftUI

struct SampleHomeView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Basics") {
                    NavigationLink("Same Content", destination: SameContentSample())
                    NavigationLink("Different Views by Type", destination: DifferentViewsSample())
                }

                Section("Layout & Style") {
                    NavigationLink("Fixed vs Scrollable", destination: LayoutStyleSample())
                    NavigationLink("Real-time Label (selectionProgress)", destination: ScrollableLabelSample())
                    NavigationLink("Indicator Customization", destination: IndicatorStyleSample())
                    NavigationLink("Separator", destination: SeparatorSample())
                    NavigationLink("Safe Area", destination: SafeAreaSample())
                }

                Section("Interaction") {
                    NavigationLink("Swipe Disabled (Instant Switch)", destination: SwipeDisabledSample())
                    NavigationLink("Runtime Swipe Toggle", destination: RuntimeSwipeToggleSample())
                }

                Section("Selection") {
                    NavigationLink("Preset Selection (by id)", destination: PresetSelectionSample())
                    NavigationLink("Deep Link / Programmatic", destination: DeepLinkSample())
                    NavigationLink("Observe Tab Changes", destination: ObserveChangeSample())
                }

                Section("Dynamic Data") {
                    NavigationLink("Dynamic / Async Tabs", destination: DynamicTabsSample())
                    NavigationLink("State Preservation (append / reorder)", destination: StatePreservationSample())
                }

                Section("Accessibility") {
                    NavigationLink("VoiceOver", destination: VoiceOverSample())
                }
            }
            .navigationTitle("TabPagerX Samples")
        }
        // Use stack style so pushing a full-screen pager behaves predictably on iPad too.
        .navigationViewStyle(.stack)
    }
}
