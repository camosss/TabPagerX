//
//  SampleSupport.swift
//  TabPagerXSample
//
//  Shared helpers used across the sample cases.
//  Nothing here is part of TabPagerX itself — these are just small view
//  building blocks so each case file can focus on the library usage.
//

import SwiftUI

// MARK: - Case Description Banner

/// A short banner shown at the top of a case screen.
///
/// Each sample screen opens with one of these so the reader knows, at a glance,
/// what the case is demonstrating without having to read the whole file.
struct CaseBanner: View {

    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.secondarySystemBackground))
    }
}

// MARK: - Demo Content Block

/// A simple, colorful page body reused by several cases as tab *content*.
///
/// It intentionally contains a `ScrollView` so cases that talk about
/// "per-tab state preservation" have real scroll state to preserve.
struct DemoContentBlock: View {

    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(color)

                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)

                // Enough rows to make the page scrollable, so switching tabs
                // and coming back visibly keeps (or resets) the scroll offset.
                ForEach(0..<20, id: \.self) { row in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(row.isMultiple(of: 2) ? 0.18 : 0.10))
                        .frame(height: 56)
                        .overlay(
                            Text("Row \(row)")
                                .font(.subheadline)
                                .foregroundColor(color)
                        )
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Shared Palette

/// A fixed palette so cases can pick stable, distinct colors by index.
enum SamplePalette {
    static let colors: [Color] = [
        .blue, .green, .orange, .purple, .pink, .teal, .indigo, .red, .cyan, .mint
    ]

    /// Returns a color for the given index, wrapping around if needed.
    static func color(_ index: Int) -> Color {
        colors[index % colors.count]
    }
}
