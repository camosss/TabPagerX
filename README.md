# SwiftUITabPager

![Swift Version](https://img.shields.io/badge/Swift-5.5-orange.svg)
![Release Version](https://img.shields.io/badge/Release-4.0.0-blue.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2015.0%2B-lightgrey.svg)
![SPM](https://img.shields.io/badge/SPM-compatible-green.svg)
![CocoaPods](https://img.shields.io/badge/CocoaPods-compatible-green.svg)
[![CI](https://github.com/camosss/SwiftUITabPager/actions/workflows/ci.yml/badge.svg)](https://github.com/camosss/SwiftUITabPager/actions/workflows/ci.yml)

A data-driven SwiftUI tab pager — built for tab lists that come from an API and change at runtime. iOS 15+.

<p align="center">
  <img src="https://github.com/user-attachments/assets/30816226-5f96-4628-a8d2-8211b876c5fc" alt="Same Content demo" width="250" />
  <img src="https://github.com/user-attachments/assets/51612cbc-b36d-4f62-a687-e28ab1fce4d0" alt="State preservation demo" width="250" />
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
- **Configurable Layouts**: Fixed/Scrollable tab bar with spacing and padding controls.
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

<br>

### Same Content (all items share the same view)
- Ideal for simple static lists or repeating the same layout.
- All tabs use the same view structure with different data.
<p align="center">
  <img src="https://github.com/user-attachments/assets/30816226-5f96-4628-a8d2-8211b876c5fc" alt="Same Content demo" width="280" />
</p>

```swift
struct TabItem: Identifiable, Equatable {
    let id: String
    let title: String
    let content: String
    let color: Color
}

@State private var selection: String? = nil

private let items = [
    TabItem(id: "home", title: "Home", content: "Welcome to Home", color: .blue),
    TabItem(id: "search", title: "Search", content: "Search content", color: .green),
    TabItem(id: "profile", title: "Profile", content: "Profile content", color: .orange)
]

TabPager(
    selection: $selection,
    items: items
) { item in
    VStack {
        Text(item.content)
            .font(.title2)
            .foregroundColor(item.color)
        Rectangle()
            .fill(item.color)
            .frame(height: 200)
            .cornerRadius(12)
    }
    .padding()

} label: { item, state in
    Text(item.title)
        .font(state.isSelected ? .headline : .body)
        .foregroundColor(state.isSelected ? item.color : .secondary)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
}
.tabBarLayoutStyle(.fixed)
.tabIndicatorStyle(height: 3, color: .blue, horizontalInset: 16)
```

<br>

### Different Views by Type (render different view per type)
- Renders different views based on each item's `type`.
- Useful when each tab needs heterogeneous UI.
<p align="center">
  <img src="https://github.com/user-attachments/assets/e39a02f5-11cd-4825-b3ad-5932432cfa17" alt="Different Views by Type demo" width="280" />
</p>

```swift
struct MixedTabItem: Identifiable, Equatable {
    let id: String
    let type: TabItemType
    let title: String

    enum TabItemType: Equatable {
        case text(String)
        case image(String)
        case custom
    }
}

@State private var selection: String? = nil

private let items = [
    MixedTabItem(id: "text", type: .text("Hello World"), title: "Text"),
    MixedTabItem(id: "image", type: .image("star.fill"), title: "Image"),
    MixedTabItem(id: "custom", type: .custom, title: "Custom")
]

TabPager(
    selection: $selection,
    items: items
) { item in
    switch item.type {
    case .text(let text):
        Text(text)
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    case .image(let name):
        Image(systemName: name)
            .font(.system(size: 60))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    case .custom:
        Circle()
            .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 100, height: 100)
    }

} label: { item, state in
    HStack {
        if case .image = item.type {
            Image(systemName: "photo")
        } else if case .custom = item.type {
            Image(systemName: "star.circle")
        }
        Text(item.title)
    }
    .font(state.isSelected ? .headline : .body)
    .foregroundColor(state.isSelected ? .blue : .secondary)
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
}
.tabIndicatorStyle(height: 4, color: .purple)
```

<br>

### Scrollable Tabs + Real-time Labels
- Scrollable layout for many tabs with button spacing and side padding.
- `state.selectionProgress` (0...1) follows your finger — interpolate color, opacity, or scale for a continuous transition.

<p align="center">
  <img src="https://github.com/user-attachments/assets/5dd27b8c-63ea-4c6e-a98c-1c7e1668c218" alt="Scrollable tabs with real-time label tracking demo" width="280" />
</p>

```swift
@State private var selection: String? = nil

private let items = [
    CategoryItem(id: "all", title: "All", emoji: "🌐", color: .blue),
    CategoryItem(id: "music", title: "Music", emoji: "🎵", color: .pink),
    CategoryItem(id: "sports", title: "Sports", emoji: "⚽", color: .green),
    // ...
]

TabPager(
    selection: $selection,
    items: items
) { item in
    VStack(spacing: 16) {
        Text(item.emoji).font(.system(size: 80))
        Text(item.title).font(.title).foregroundColor(item.color)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)

} label: { item, state in
    Text("\(item.emoji) \(item.title)")
        .font(.subheadline)
        .foregroundColor(item.color.opacity(0.35 + 0.65 * state.selectionProgress))
        .scaleEffect(1 + 0.08 * state.selectionProgress)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
}
.tabBarLayoutStyle(.scrollable)
.tabBarLayoutConfig(buttonSpacing: 4, sidePadding: 12)
.tabIndicatorStyle(height: 3, color: .blue, cornerRadius: 1.5)
```

<br>

### Dynamic / Async Tabs
- Safe with empty or async-loaded items — no `isLoading` guard needed.
- Tabs render automatically when data arrives; the first tab (or a preset id) is selected.

<p align="center">
  <img src="https://github.com/user-attachments/assets/a5e5e7da-c429-4a66-bfdf-6fe0fe5cd557" alt="Dynamic async tabs demo" width="280" />
</p>

```swift
@State private var selection: Item.ID? = nil
@State private var items: [Item] = [] // starts empty

var body: some View {
    VStack {
        Button("Reload") { loadData() }

        // No isLoading guard needed — safe with empty items
        TabPager(
            selection: $selection,
            items: items
        ) { item in
            Text(item.content)
                .font(.title2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        } label: { item, state in
            HStack {
                Image(systemName: item.icon)
                Text(item.title)
            }
            .font(state.isSelected ? .headline : .body)
            .foregroundColor(state.isSelected ? item.color : .secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .tabBarLayoutStyle(.scrollable)
        .tabIndicatorStyle(height: 3, color: .green, horizontalInset: 8)
    }
    .onAppear { loadData() }
}

func loadData() {
    items = []
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        items = [/* fetched data */]
    }
}
```

<br>

### State Preservation (append / reorder)
- Pages are cached by item **id**, so each tab keeps its scroll position and internal state across item updates.
- Appending a tab preserves the existing tabs; reordering moves each page with its item; removing drops only that page.

<p align="center">
  <img src="https://github.com/user-attachments/assets/51612cbc-b36d-4f62-a687-e28ab1fce4d0" alt="State preservation across append and shuffle demo" width="280" />
</p>

```swift
@State private var selection: String? = nil
@State private var items: [TabItem] = [/* ... */]

TabPager(selection: $selection, items: items) { item in
    /* a scrollable page */
} label: { item, state in
    /* label */
}

// Later — existing tabs keep their state because their ids are unchanged
items.append(TabItem(id: "new", title: "New"))
items.shuffle()
```

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

<br>

### Swipe Disabled (instant tab switch)
- When swipe is disabled, tapping a tab switches content instantly with no slide animation.
- Can be toggled at runtime.

```swift
TabPager(
    selection: $selection,
    items: items
) { item in
    Text(item.title)
        .font(.largeTitle)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

} label: { item, state in
    Text(item.title)
        .font(state.isSelected ? .headline : .body)
        .foregroundColor(state.isSelected ? item.color : .secondary)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
}
.tabBarLayoutStyle(.fixed)
.tabIndicatorStyle(height: 3, color: .red)
.contentSwipeEnabled(false) // no swipe, no slide animation on tap
```

<br>

For more examples, browse the [sample app](https://github.com/camosss/SwiftUITabPager/tree/main/Example/SwiftUITabPagerSample/SwiftUITabPagerSample). Each usage case is a focused, heavily commented file grouped by topic:

| Topic | Cases |
|-------|-------|
| **Basics** | Same Content, Different Views by Type |
| **Layout & Style** | Fixed vs Scrollable, Real-time Label (`selectionProgress`), Indicator Customization, Separator, Safe Area |
| **Interaction** | Swipe Disabled, Runtime Swipe Toggle |
| **Selection** | Preset Selection (by id), Deep Link / Programmatic, Observe Tab Changes |
| **Dynamic Data** | Dynamic / Async Tabs, State Preservation (append / reorder) |
| **Accessibility** | VoiceOver |

```bash
# Run the sample app (the Xcode project is generated, not checked in)
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

<p align="center">
  <img src="https://github.com/user-attachments/assets/aab1980a-7c5e-40e3-a763-4d85fd072405" alt="Fixed vs scrollable layout demo" width="280" />
</p>

```swift
// Fixed: tabs share equal width across the screen (default)
.tabBarLayoutStyle(.fixed)

// Scrollable: tabs size to content, horizontally scrollable
.tabBarLayoutStyle(.scrollable)
```

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

### contentIgnoresSafeArea
- By default the pager **respects the safe area**, so it can sit above tab bars or toolbars without layout issues.
- For full-screen content, opt in to extend into safe area edges.

<p align="center">
  <img src="https://github.com/user-attachments/assets/f2da8a61-80c4-4b39-aaf7-46db2047bbcb" alt="Safe area default vs extended demo" width="280" />
</p>

```swift
// Full-screen content — extend into the bottom safe area (v2 default behavior)
.contentIgnoresSafeArea()

// Or specify edges explicitly
.contentIgnoresSafeArea(edges: [.bottom, .horizontal])
```

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
  <img src="https://github.com/user-attachments/assets/da568ee0-418c-4ba8-9af8-4a3ae8d13e53" alt="Separator on and off demo" width="280" />
</p>

### onTabChanged
- Observe changes of the selected item via callback.
- Keyed to the item's id — reordering tabs doesn't fire it unless the selected item actually changes.

```swift
.onTabChanged { item in
    print("Selected tab: \(item.title)")
}
```

<br>

## 💥 Migrating from 2.x

The 2.x index-based initializer was removed in 4.0 — update call sites as follows:

| 2.x | 4.0 |
|---|---|
| `selectedIndex: Binding<Int>` | `selection: Binding<Item.ID?>` |
| `initialIndex: 2` | preset the binding: `@State var selection: ID? = "someId"` |
| `tabTitle: { item, isSelected in }` | `label: { item, state in }` — use `state.isSelected` |
| bottom safe area always ignored | respected by default — add `.contentIgnoresSafeArea()` to keep the old behavior |

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
