# TabPagerX

![Swift Version](https://img.shields.io/badge/Swift-5.5-orange.svg)
![Release Version](https://img.shields.io/badge/Release-3.0.0-blue.svg)
![SPM](https://img.shields.io/badge/SPM-compatible-green.svg)
![CocoaPods](https://img.shields.io/badge/CocoaPods-compatible-green.svg)
[![CI](https://github.com/camosss/TabPagerX/actions/workflows/ci.yml/badge.svg)](https://github.com/camosss/TabPagerX/actions/workflows/ci.yml)

Effortless SwiftUI tab pager with dynamic customization.

`TabPagerX` is a SwiftUI-based library designed to help iOS developers create customizable tab pagers with ease.
It offers flexible layouts, per-tab state preservation, and extensive styling options for tab labels and indicators, making it a perfect choice for building tab-based navigation in your SwiftUI applications.

<br>

## 💥 Features
- **ID-based Selection**: Bind selection to your item's `id` — it survives reorders and removals, and deep links can select a tab without knowing its position.
- **Generic Data API**: Work with any `Identifiable & Equatable` data model.
- **Type-safe Builders**: Closure-based `content` and `label` per item.
- **Static & Dynamic Tabs**: Supports both fixed arrays and API-driven dynamic lists — safe with empty or async-loaded items.
- **State Preservation**: Each tab's page (scroll position, internal state) is cached by item id — appending or reordering tabs keeps existing state.
- **Real-time Label & Indicator Tracking**: `TabState.selectionProgress` interpolates 0→1 as your finger swipes, for the label and the indicator alike.
- **Configurable Layouts**: Fixed/Scrollable tab bar with spacing and padding controls.
- **Indicator Customization**: Height, color, corner radius, horizontal inset, animation.
- **Optional Separator**: Built-in separator between TabBar and content via modifier.
- **Gesture Navigation**: Enable/disable swipe between pages — togglable at runtime. Disabling swipe also removes tab transition animation.
- **VoiceOver Support**: Tabs are announced as buttons with selection state and position.

<br>

## 💥 Requirements

- iOS 15.0+
- Swift 5.5+
- Xcode 15.0+

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
private let items = [..]

TabPagerX(
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
<table style="width:100%; table-layout:fixed; border-collapse:collapse;">
  <tr>
    <td style="width:50%; padding:0 6px 0 0; vertical-align:top;">
      <img src="https://github.com/user-attachments/assets/f74a9dc8-7c4c-402b-9732-547c5d8bdf9e"
           alt="Same Content Example 1"
           style="width:100%; max-width:420px; height:auto; display:block; margin:0 auto;" />
    </td>
    <td style="width:50%; padding:0 0 0 6px; vertical-align:top;">
      <img src="https://github.com/user-attachments/assets/806c7c89-1c56-4228-8e57-656fdd6329a8"
           alt="Same Content Example 2"
           style="width:100%; max-width:420px; height:auto; display:block; margin:0 auto;" />
    </td>
  </tr>
</table>

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

TabPagerX(
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
<table style="width:100%; table-layout:fixed; border-collapse:collapse;">
  <tr>
    <td style="width:50%; padding:0 6px 0 0; vertical-align:top;">
      <img src="https://github.com/user-attachments/assets/30ba27e8-0734-4dc7-9af6-f5bdf539bb66"
           alt="Different Views - Image 1"
           style="width:100%; max-width:420px; height:auto; display:block; margin:0 auto;" />
    </td>
    <td style="width:50%; padding:0 0 0 6px; vertical-align:top;">
      <img src="https://github.com/user-attachments/assets/585ba450-9aef-484f-a3de-5d1dc886fa15"
           alt="Different Views - Image 2"
           style="width:100%; max-width:420px; height:auto; display:block; margin:0 auto;" />
    </td>
  </tr>
</table>

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

TabPagerX(
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

### Dynamic / Async Tabs
- Safe with empty or async-loaded items — no `isLoading` guard needed.
- Tabs render automatically when data arrives; the first tab (or a preset id) is selected.
- With stable ids, appending tabs later keeps existing tabs' state intact.

```swift
@State private var selection: Item.ID? = nil
@State private var items: [Item] = [] // starts empty

var body: some View {
    VStack {
        Button("Reload") { loadData() }

        // No isLoading guard needed — safe with empty items
        TabPagerX(
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

### Scrollable Tabs + Real-time Labels
- Scrollable layout for many tabs with button spacing and side padding.
- `state.selectionProgress` (0...1) follows your finger — interpolate color, opacity, or scale for a continuous transition.

```swift
@State private var selection: String? = nil

private let items = [
    CategoryItem(id: "all", title: "All", emoji: "🌐", color: .blue),
    CategoryItem(id: "music", title: "Music", emoji: "🎵", color: .pink),
    CategoryItem(id: "sports", title: "Sports", emoji: "⚽", color: .green),
    // ...
]

TabPagerX(
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

### Preset Selection / Deep Links
- Preset the binding to start on a specific tab — no index math, works regardless of server-driven tab order.

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
TabPagerX(
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

For more examples, see `TabPagerXSample` in the sample app. (link: [TabPagerXSample](https://github.com/camosss/TabPagerX/blob/main/Example/TabPagerXSample/TabPagerXSample/TabPagerXSample.swift))

<br>

## 💥 Configuration

### layoutStyle
- Set Tab Bar Layout Style.
- Choose between fixed or scrollable layouts.
- Custom tab views are fully supported in both layouts.

<table style="width:100%; table-layout:fixed; border-collapse:collapse;">
  <tr>
    <td style="width:50%; text-align:center; vertical-align:top; padding:0 6px 0 0;">
      <pre style="margin:0 0 6px 0;"><code>.tabBarLayoutStyle(.fixed)</code></pre>
      <img src="https://github.com/user-attachments/assets/7b5e28f0-2a84-4228-bbd5-413a96b9524d"
           alt="Fixed layout screenshot"
           style="width:100%; max-width:420px; height:auto; display:block; margin:0 auto;" />
    </td>
    <td style="width:50%; text-align:center; vertical-align:top; padding:0 0 0 6px;">
      <pre style="margin:0 0 6px 0;"><code>.tabBarLayoutStyle(.scrollable)</code></pre>
      <img src="https://github.com/user-attachments/assets/5be3f178-2a30-42a6-8542-298a9d92d860"
           alt="Scrollable layout screenshot"
           style="width:100%; max-width:420px; height:auto; display:block; margin:0 auto;" />
    </td>
  </tr>
</table>

```swift
// Fixed: tabs share equal width across the screen (default)
.tabBarLayoutStyle(.fixed)

// Scrollable: tabs size to content, horizontally scrollable
.tabBarLayoutStyle(.scrollable)
```

### layoutConfig
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

### indicatorStyle
- Customize Tab underline (indicator) with `.tabIndicatorStyle(...)`.
- You can set `height`, `color`, `horizontalInset`, `cornerRadius`, and `animationDuration`.
- The indicator tracks your finger in real-time during swipe gestures.

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

// No indicator (default — height: 0, color: .clear)
```

### isSwipeEnabled
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

### separatorStyle
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

<table style="width:100%; table-layout:fixed; border-collapse:collapse;">
  <tr>
    <td style="width:50%; padding:0 6px 0 0; vertical-align:top;">
      <img src="https://github.com/user-attachments/assets/6002f1bc-0b4a-4943-af22-295153501f81"
           alt="Separator ON"
           style="width:100%; max-width:420px; height:auto; display:block; margin:0 auto;" />
    </td>
    <td style="width:50%; padding:0 0 0 6px; vertical-align:top;">
      <img src="https://github.com/user-attachments/assets/caf0ec84-f7a3-4da0-8a94-c934a4ad2630"
           alt="Separator OFF"
           style="width:100%; max-width:420px; height:auto; display:block; margin:0 auto;" />
    </td>
  </tr>
</table>

### onTabChanged
- Observe tab index changes via callback.
- For the selected item itself, observe your `selection` binding with `onChange`.

```swift
.onTabChanged { index in
    print("Selected tab: \(index)")
}
```

<br>

## 💥 Migrating from 2.x

The 2.x index-based initializer still compiles (deprecated) — migrate at your own pace:

| 2.x | 3.0 |
|---|---|
| `selectedIndex: Binding<Int>` | `selection: Binding<Item.ID?>` |
| `initialIndex: 2` | preset the binding: `@State var selection: ID? = "someId"` |
| `tabTitle: { item, isSelected in }` | `label: { item, state in }` — use `state.isSelected` |

```swift
// 2.x
TabPagerX(selectedIndex: $index, initialIndex: 1, items: items) { item in
    ...
} tabTitle: { item, isSelected in
    Text(item.title).foregroundColor(isSelected ? .blue : .gray)
}

// 3.0
TabPagerX(selection: $selection, items: items) { item in
    ...
} label: { item, state in
    Text(item.title).foregroundColor(state.isSelected ? .blue : .gray)
}
```

Also make sure your items use **stable ids** — replace `let id = UUID()` with an identity from your data (e.g. a server id or a constant string).

<br>

## 💥 Installation

### SPM
In Xcode, go to File > Add Packages

```
https://github.com/camosss/TabPagerX.git
```

### CocoaPods

Add to your `Podfile`

``` ruby
pod 'TabPagerX'
```

Run
```
pod install
```

<br>

## 💥 License
`TabPagerX` is released under an MIT license. See [License](https://github.com/camosss/TabPagerX/blob/main/LICENSE) for more information.
