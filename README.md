# SwiftUITabPager

![Swift Version](https://img.shields.io/badge/Swift-5.5-orange.svg)
![Release Version](https://img.shields.io/badge/Release-4.1.1-blue.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2015.0%2B-lightgrey.svg)
![SPM](https://img.shields.io/badge/SPM-compatible-green.svg)
![CocoaPods](https://img.shields.io/badge/CocoaPods-compatible-green.svg)
[![CI](https://github.com/camosss/SwiftUITabPager/actions/workflows/ci.yml/badge.svg)](https://github.com/camosss/SwiftUITabPager/actions/workflows/ci.yml)

A data-driven SwiftUI tab pager — built for tab lists that come from an API and change at runtime. iOS 15+.

<p align="center">
  <img src="https://github.com/user-attachments/assets/0ce33828-57cb-4ee5-952c-a209a0196135" alt="Different views by type demo" width="250" />
  <img src="https://github.com/user-attachments/assets/5367584d-f5ea-42fd-91fa-79de003ff362" alt="State preservation demo" width="250" />
  <img src="https://github.com/user-attachments/assets/67e3f2eb-9ed5-4f74-a152-7c132539e22a" alt="Indicator customization demo" width="250" />
</p>

`SwiftUITabPager` builds the tab bar and the pages from **your data**, not from a statically declared list of views. You pass an array of `Identifiable` items — so a tab set that arrives from an API, gets appended, reordered or removed at runtime needs no special handling, and an empty array while loading is safe.

Each page is cached by its item `id`, so tabs keep their scroll position and internal state across those updates. Paging is backed by `UIPageViewController`, so swipe inertia, bounce and nested scrolling behave exactly like the system — and it runs on **iOS 15**, not just the latest OS.

<br>

## Contents

- [Features](#-features)
- [Anatomy](#-anatomy)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Usage](#-usage)
- [Configuration](#-configuration)
- [Migrating from 2.x](#-migrating-from-2x)
- [Contributing](#-contributing)
- [About](#-about)
- [License](#-license)

<br>

## 💥 Features

**Built for tabs that change**
- **Data-Driven Tabs**: Pass `[Item]` and the pager renders from it. Static arrays, API-driven lists, runtime append / reorder / remove — all the same code path, and an empty array is safe, so no `isLoading` guard around the pager.
- **State Preservation**: Pages are cached by item `id`, so each tab keeps its scroll position and internal state when the item list changes.
- **ID-based Selection**: Bind selection to the item's `id` — it survives reorders and removals, and a deep link can select a tab without knowing its position.
- **iOS 15+**: No need to raise your deployment target to adopt it.

**Interaction**
- **Native Paging**: Backed by `UIPageViewController` — system swipe physics, inertia and nested scrolling, not a hand-rolled drag gesture.
- **Real-time Label & Indicator Tracking**: `TabState.selectionProgress` interpolates 0→1 as your finger swipes, for the label and the indicator alike.
- **Gesture Navigation**: Enable/disable swipe between pages — togglable at runtime. Disabling swipe also removes tab transition animation.
- **VoiceOver Support**: Tabs are announced as buttons with selection state and position.

**Styling**
- **Generic Data API**: Work with any `Identifiable & Equatable` data model, with closure-based `content` and `label` per item.
- **Configurable Layouts**: Fixed/Scrollable tab bar with spacing and padding controls. Fixed tabs are pinned to an equal share, so long labels can't push the bar off screen.
- **Indicator Customization**: Height, color, corner radius, horizontal inset, animation.
- **Optional Separator**: Built-in separator between TabBar and content via modifier.

<br>

## 💥 Anatomy

A `TabPager` is a vertical stack of three parts. Each part maps to the API that controls it:

```
┌───────────────────────────────────────────────┐
│   Home       Search       Profile             │ ← tab labels   label: { item, state in }
│  ▔▔▔▔▔▔                                       │ ← indicator    .tabIndicatorStyle(…)
│ ───────────────────────────────────────────── │ ← separator    .tabBarSeparator(…)
│                                               │
│                 page content                  │ ← content      content: { item in }
│            ◀ swipe to change tabs ▶           │   paging       .contentSwipeEnabled(…)
│                                               │
└───────────────────────────────────────────────┘
        ▲
        └ tab bar layout   .tabBarLayoutStyle(.fixed / .scrollable)
                           .tabBarLayoutConfig(buttonSpacing:sidePadding:)
```

<br>

## 💥 Requirements

- iOS 15.0+
- Swift 5.5+
- Xcode 15.0+

<br>

## 💥 Installation

### SPM
In Xcode, go to File > Add Packages

```
https://github.com/camosss/SwiftUITabPager.git
```

### CocoaPods

Add to your `Podfile`

``` ruby
pod 'SwiftUITabPager'
```

Run
```
pod install
```

<br>

## 💥 Usage

### Getting Started

- Bind a `@State` optional id to `selection` to track the current tab.
  - `nil` until items arrive — the first tab is then selected automatically.
  - Preset an id (e.g. `= "profile"`) to start on a specific tab.
- Provide `items` (any `Identifiable & Equatable` type).
- Define each tab's content using SwiftUI views via `content` closure.
- Use the `label` closure to build each tab's label from the item and its `TabState`.

```swift
@State private var selection: MyItem.ID? = nil
private let items = [/* your items */]

TabPager(
    selection: $selection,
    items: items
) { item in
    /* content */
} label: { item, state in
    /* label — state.isSelected / state.selectionProgress */
}
```

> **Use stable ids.** Give items a stable identity (`let id: String` from your data), not `UUID()` created on the fly — stable ids are what make selection and per-tab state survive item updates.

> **Pages fill their area.** Each page gets the whole page frame, so `.background()` on your page content covers the entire tab. One SwiftUI gotcha to know: if your page is a `ScrollView` whose content doesn't stretch horizontally, SwiftUI sizes the scroll view to that content and draws its scroll indicator mid-screen. Add `.frame(maxWidth: .infinity)` to the content to push it back to the edge.

The sections below show only what is distinctive about each case — every one links to a complete, runnable screen in the sample app.

<br>

### Same Content (all items share the same view)
- Ideal for simple static lists or repeating the same layout.
- All tabs use the same view structure with different data.

<p align="center">
  <img src="https://github.com/user-attachments/assets/30816226-5f96-4628-a8d2-8211b876c5fc" alt="Same Content demo" width="280" />
</p>

```swift
TabPager(selection: $selection, items: items) { item in
    VStack {
        Text(item.content).foregroundColor(item.color)
        Rectangle().fill(item.color).frame(height: 200).cornerRadius(12)
    }
    .padding()

} label: { item, state in
    Text(item.title)
        .font(state.isSelected ? .headline : .body)
        .foregroundColor(state.isSelected ? item.color : .secondary)
}
.tabBarLayoutStyle(.fixed)
.tabIndicatorStyle(height: 3, color: .blue, horizontalInset: 16)
```

📄 [`Basics/SameContentSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Basics/SameContentSample.swift)

<br>

### Different Views by Type (render different view per type)
- Renders different views based on each item's `type`.
- Useful when each tab needs heterogeneous UI.

<p align="center">
  <img src="https://github.com/user-attachments/assets/0ce33828-57cb-4ee5-952c-a209a0196135" alt="Different Views by Type demo" width="280" />
</p>

```swift
TabPager(selection: $selection, items: items) { item in
    // Any view tree per tab — a List and a grid keep their own scrolling
    // while the pager keeps the horizontal swipe.
    switch item.kind {
    case .text(let text):
        Text(text).font(.largeTitle)
    case .list:
        List { /* rows */ }
    case .grid:
        ScrollView { LazyVGrid(columns: columns) { /* cells */ } }
    case .custom:
        Circle().fill(.purple)
    }

} label: { item, state in
    // The label can branch on the item too
    HStack(spacing: 4) {
        if let icon = item.icon { Image(systemName: icon).font(.caption) }
        Text(item.title)
    }
    .lineLimit(1)
    .foregroundColor(state.isSelected ? .purple : .secondary)
}
```

📄 [`Basics/DifferentViewsSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Basics/DifferentViewsSample.swift)

<br>

### Scrollable Tabs + Real-time Labels
- Scrollable layout for many tabs with button spacing and side padding.
- `state.selectionProgress` (0...1) follows your finger — interpolate color, opacity, or scale for a continuous transition.

<p align="center">
  <img src="https://github.com/user-attachments/assets/216d973e-603e-4917-92a6-5a45307f4fbe" alt="Scrollable tabs with real-time label tracking demo" width="280" />
</p>

```swift
label: { item, state in
    // selectionProgress interpolates while the finger moves, so the label
    // fades and grows with the swipe instead of snapping at the end
    Text("\(item.emoji) \(item.title)")
        .foregroundColor(item.color.opacity(0.35 + 0.65 * state.selectionProgress))
        .scaleEffect(1 + 0.08 * state.selectionProgress)
}
.tabBarLayoutStyle(.scrollable)
.tabBarLayoutConfig(buttonSpacing: 4, sidePadding: 12)
```

📄 [`LayoutAndStyle/ScrollableLabelSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/LayoutAndStyle/ScrollableLabelSample.swift)

<br>

### Dynamic / Async Tabs
- Safe with empty or async-loaded items — no `isLoading` guard needed.
- Tabs render automatically when data arrives; the first tab (or a preset id) is selected.

<p align="center">
  <img src="https://github.com/user-attachments/assets/6a83e0aa-0528-4403-bcdb-86008175db4f" alt="Dynamic async tabs demo" width="280" />
</p>

```swift
@State private var items: [Item] = []   // starts empty, and that is fine

// No isLoading guard around the pager — an empty array simply renders nothing
TabPager(selection: $selection, items: items) { item in ... } label: { ... }

func loadData() {
    Task { items = await api.fetchTabs() }   // tabs appear when this lands
}
```

📄 [`DynamicData/DynamicTabsSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/DynamicData/DynamicTabsSample.swift)

<br>

### State Preservation (append / reorder)
- Pages are cached by item **id**, so each tab keeps its scroll position and internal state across item updates.
- Appending a tab preserves the existing tabs; reordering moves each page with its item; removing drops only that page.

<p align="center">
  <img src="https://github.com/user-attachments/assets/5367584d-f5ea-42fd-91fa-79de003ff362" alt="State preservation across append and shuffle demo" width="280" />
</p>

```swift
// Existing tabs keep their scroll position because their ids are unchanged
items.append(TabItem(id: "new", title: "New"))
items.shuffle()
```

📄 [`DynamicData/StatePreservationSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/DynamicData/StatePreservationSample.swift)

<br>

### Preset Selection / Deep Links
- Preset the binding to start on a specific tab — no index math, works regardless of server-driven tab order.
- Assigning the id from anywhere (a deep link, a button) moves the pager to that tab.

```swift
// Start on the "profile" tab once items load
@State private var selection: String? = "profile"

// Deep link later — just assign the id
selection = "event"
```

📄 [`Selection/PresetSelectionSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Selection/PresetSelectionSample.swift) · [`Selection/DeepLinkSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Selection/DeepLinkSample.swift)

<br>

### Swipe Disabled (instant tab switch)
- When swipe is disabled, tapping a tab switches content instantly with no slide animation.
- Can be toggled at runtime.

```swift
.contentSwipeEnabled(false) // no swipe, no slide animation on tap
```

📄 [`Interaction/SwipeDisabledSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Interaction/SwipeDisabledSample.swift) · [`Interaction/RuntimeSwipeToggleSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Interaction/RuntimeSwipeToggleSample.swift)

<br>

### Sample app

Every case above, plus a few more, is a focused and heavily commented screen:

| Topic | Cases |
|-------|-------|
| **Basics** | [Same Content](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Basics/SameContentSample.swift), [Different Views by Type](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Basics/DifferentViewsSample.swift) |
| **Layout & Style** | [Fixed vs Scrollable](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/LayoutAndStyle/LayoutStyleSample.swift), [Real-time Label](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/LayoutAndStyle/ScrollableLabelSample.swift), [Indicator Customization](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/LayoutAndStyle/IndicatorStyleSample.swift), [Separator](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/LayoutAndStyle/SeparatorSample.swift), [Safe Area](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/LayoutAndStyle/SafeAreaSample.swift) |
| **Interaction** | [Swipe Disabled](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Interaction/SwipeDisabledSample.swift), [Runtime Swipe Toggle](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Interaction/RuntimeSwipeToggleSample.swift) |
| **Selection** | [Preset Selection](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Selection/PresetSelectionSample.swift), [Deep Link](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Selection/DeepLinkSample.swift), [Observe Tab Changes](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Selection/ObserveChangeSample.swift) |
| **Dynamic Data** | [Dynamic / Async Tabs](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/DynamicData/DynamicTabsSample.swift), [State Preservation](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/DynamicData/StatePreservationSample.swift) |
| **Accessibility** | [VoiceOver](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Accessibility/VoiceOverSample.swift) |

```bash
# Run them — the Xcode project is generated, not checked in
brew install xcodegen
cd Example/SwiftUITabPagerSample && xcodegen generate
open SwiftUITabPagerSample.xcodeproj
```

<br>

## 💥 Configuration

### tabBarLayoutStyle
- Set Tab Bar Layout Style.
- Choose between fixed or scrollable layouts.
- Custom tab views are fully supported in both layouts.
- In `.fixed`, every tab is pinned to exactly the same share of the bar, so a long title — or any title once the user raises the text size — is clipped inside its own tab instead of pushing the bar past the screen edge.
- Debug builds print a warning when a label needs more room than its tab has, so you find out on your machine rather than from a screenshot.

<p align="center">
  <img src="https://github.com/user-attachments/assets/d96023fc-1a9b-410c-a0c7-b29a4a145f1f" alt="Fixed vs scrollable layout demo" width="280" />
</p>

```swift
// Fixed: tabs share equal width across the screen (default).
// Best for a few short titles — reach for .scrollable once they get long.
.tabBarLayoutStyle(.fixed)

// Scrollable: tabs size to content, horizontally scrollable
.tabBarLayoutStyle(.scrollable)
```

📄 [`LayoutAndStyle/LayoutStyleSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/LayoutAndStyle/LayoutStyleSample.swift)

### tabBarLayoutConfig
- Configure Tab Bar Layout.
- Adjust `buttonSpacing` and `sidePadding`. (defaults to 0)
  - `buttonSpacing`: spacing between each tab button
  - `sidePadding`: horizontal padding applied to the whole tab bar (left & right)

```swift
// No spacing (default)
.tabBarLayoutConfig(buttonSpacing: 0, sidePadding: 0)

// With spacing and padding
.tabBarLayoutConfig(buttonSpacing: 8, sidePadding: 12)
```

### tabIndicatorStyle
- Customize Tab underline (indicator) with `.tabIndicatorStyle(...)`.
- You can set `height`, `color`, `horizontalInset`, `cornerRadius`, and `animationDuration`.
- The indicator tracks your finger in real-time during swipe gestures.
- The default is a 2pt accent-colored underline; pass `.hidden` to remove it.

<p align="center">
  <img src="https://github.com/user-attachments/assets/67e3f2eb-9ed5-4f74-a152-7c132539e22a" alt="Indicator customization demo" width="280" />
</p>

```swift
// Thin blue underline
.tabIndicatorStyle(height: 2, color: .blue)

// Rounded pill with inset
.tabIndicatorStyle(
    height: 4,
    color: .orange,
    horizontalInset: 20,
    cornerRadius: 2,
    animationDuration: 0.25
)

// No indicator
.tabIndicatorStyle(.hidden)
```

📄 [`LayoutAndStyle/IndicatorStyleSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/LayoutAndStyle/IndicatorStyleSample.swift)

### contentSwipeEnabled
- Enable or Disable Content Swipe.
- Allow or disable swipe gesture to switch between tabs.
- Default is `true`. Use `.contentSwipeEnabled(false)` to disable swipe navigation.
- Can be toggled at runtime (e.g. while editing).
- When disabled, tab tap transitions are also instant (no slide animation).

```swift
// Swipe enabled (default) — swipe between pages with slide animation
.contentSwipeEnabled(true)

// Swipe disabled — tap only, instant content switch
.contentSwipeEnabled(false)
```

### contentIgnoresSafeArea / contentRespectsSafeArea
- The pager **fills the bottom safe area by default**, so a page reaches the bottom edge of the screen with no setup.
- Opt out with `.contentRespectsSafeArea()` when the pager sits above a tab bar or toolbar and its content must not run underneath.

<p align="center">
  <img src="https://github.com/user-attachments/assets/cac88ff5-f63a-4052-a9cd-973220aab685" alt="Safe area filled by default, toggled off" width="280" />
</p>

```swift
// Default — content already reaches the bottom edge, nothing to write

// Extend into more edges
.contentIgnoresSafeArea(edges: [.bottom, .horizontal])

// Keep the pager inside the safe area instead
.contentRespectsSafeArea()
```

📄 [`LayoutAndStyle/SafeAreaSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/LayoutAndStyle/SafeAreaSample.swift)

### tabBarSeparator
- Adds a separator line between the TabBar and the content area.
- Use to visually distinguish the tab bar from page content.

```swift
// Add separator
.tabBarSeparator(
    color: .gray.opacity(0.3),
    height: 1
)

// Full customization
.tabBarSeparator(
    color: .gray.opacity(0.2),
    height: 1,
    horizontalPadding: 16,
    isHidden: false
)
```

<p align="center">
  <img src="https://github.com/user-attachments/assets/05648052-e0a3-4624-8daa-f84870d0d532" alt="Separator color, thickness and padding demo" width="280" />
</p>

📄 [`LayoutAndStyle/SeparatorSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/LayoutAndStyle/SeparatorSample.swift)

### onTabChanged
- Observe changes of the selected item via callback.
- Keyed to the item's id — reordering tabs doesn't fire it unless the selected item actually changes.

```swift
.onTabChanged { item in
    print("Selected tab: \(item.title)")
}
```

📄 [`Selection/ObserveChangeSample.swift`](https://github.com/camosss/SwiftUITabPager/blob/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample/Selection/ObserveChangeSample.swift)

<br>

## 💥 Migrating from 2.x

The 2.x index-based initializer was removed in 4.0 — update call sites as follows:

| 2.x | 4.0 |
|---|---|
| `selectedIndex: Binding<Int>` | `selection: Binding<Item.ID?>` |
| `initialIndex: 2` | preset the binding: `@State var selection: ID? = "someId"` |
| `tabTitle: { item, isSelected in }` | `label: { item, state in }` — use `state.isSelected` |
| bottom safe area always ignored | unchanged — still filled by default, opt out with `.contentRespectsSafeArea()` |

```swift
// 2.x
TabPager(selectedIndex: $index, initialIndex: 1, items: items) { item in
    ...
} tabTitle: { item, isSelected in
    Text(item.title).foregroundColor(isSelected ? .blue : .gray)
}

// 4.0
TabPager(selection: $selection, items: items) { item in
    ...
} label: { item, state in
    Text(item.title).foregroundColor(state.isSelected ? .blue : .gray)
}
```

Also make sure your items use **stable ids** — replace `let id = UUID()` with an identity from your data (e.g. a server id or a constant string).

<br>

## 💥 Contributing

Issues and pull requests are welcome. If you find a bug or want a feature, please [open an issue](https://github.com/camosss/SwiftUITabPager/issues). For pull requests, keep changes focused and make sure the test suite passes (`⌘U`, or `xcodebuild test` on an iOS Simulator) — CI runs the same suite on every PR.

<br>

## 💥 About

Created and maintained by [camosss](https://github.com/camosss).

<br>

## 💥 License
`SwiftUITabPager` is released under an MIT license. See [License](https://github.com/camosss/SwiftUITabPager/blob/main/LICENSE) for more information.
