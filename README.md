# TabPagerX

![Swift Version](https://img.shields.io/badge/Swift-5.5-orange.svg)
![Release Version](https://img.shields.io/badge/Release-2.0.0-blue.svg)
![SPM](https://img.shields.io/badge/SPM-compatible-green.svg)
![CocoaPods](https://img.shields.io/badge/CocoaPods-compatible-green.svg)

Effortless SwiftUI tab pager with dynamic customization.

`TabPagerX` is a SwiftUI-based library designed to help iOS developers create customizable tab pagers with ease.
It offers flexible layouts, tab scroll preservation, and extensive styling options for tab buttons and indicators, making it a perfect choice for building tab-based navigation in your SwiftUI applications.

<br>

## 💥 Features
- **Generic Data API**: Work with any `Identifiable & Equatable` data model.
- **Type-safe Builders**: Closure-based `content` and `tabTitle` per item.
- **Static & Dynamic Tabs**: Supports both fixed arrays and API-driven dynamic lists.
- **Configurable Layouts**: Fixed/Scrollable tab bar with spacing and padding controls.
- **Indicator Customization**: Height, color, corner radius, horizontal inset, animation.
- **Optional Separator**: Built-in separator between TabBar and content via modifier.
- **Gesture Navigation**: Enable/disable swipe between pages.

<br>

## 💥 Requirements

- iOS 15.0+
- Swift 5.5+
- Xcode 15.0+

<br>

## 💥 Usage

### Getting Started

- Bind a `@State` variable to `selectedIndex` to track the current tab.
- Optionally set `initialIndex` (default is 0) to define which tab is shown first (applied once on first appearance).
- Provide `items` (any `Identifiable & Equatable` type).
- Define each tab's content using SwiftUI views via `content` closure.
- Use `tabTitle` closure to provide a custom tab label per item (`@ViewBuilder`).

<br>

> Note (Dynamic/API-driven tabs): When tabs are loaded asynchronously (e.g., `isLoading == true`), guard against out-of-range indices until data is ready.
> - Render a placeholder while loading, or when `items.isEmpty`.
> - Safety for async loading and index clamping will be improved in a future update.

```swift
@State private var selectedIndex = 0
@State private var isLoading = true
@State private var items: [Item] = []

var body: some View {
    Group {
        if isLoading || items.isEmpty {
            ProgressView()
        } else {
            TabPagerX(
                selectedIndex: $selectedIndex,
                items: items
            ) { item in
                /* content */
            } tabTitle: { item, isSelected in
                /* title */
            }
        }
    }
}
```

<br>

### Same Content (all items share the same view)
- Ideal for simple static lists or repeating the same layout.
- All tabs use the same view
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
@State private var selectedIndex = 0
private let items = [..]

TabPagerX(
    selectedIndex: $selectedIndex,
    initialIndex: 0, // optional
    items: items
) { item in
    Text(item.content)
    ...
    
} tabTitle: { item, isSelected in
    Text(item.title)
}
.tabBarLayoutStyle(.scrollable)
```

<br>

### Different Views by Type (render different view per type)
- Renders different views based on each item's `type`.
- Useful when each tab needs heterogeneous UI
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
@State private var selectedIndex = 0
private let items = [..]

TabPagerX(
    selectedIndex: $selectedIndex,
    items: items
) { item in
    switch item.type {
    case .text(let text):
        Text(text)
    case .image(let name):
        Image(systemName: name)
    case .custom:
        CustomView()
    }
    ...
    
} tabTitle: { item, isSelected in
    HStack {
        if case .image = item.type {
            Image(systemName: "photo")
        } else if case .text = item.type {
            Image(systemName: "star.circle")
        }
        Text(item.title)
    }
}
```

<br>

For more examples, see `TabPagerXSample` in the sample app. (link: [TabPagerXSample](https://github.com/camosss/TabPagerX/blob/main/Example/TabPagerXSample/TabPagerXSample/TabPagerXSample.swift))

<br>

## 💥 Configuration

### layoutStyle
- Set Tab Bar Layout Style
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


### layoutConfig
- Configure Tab Bar Layout
- Adjust `buttonSpacing` and `sidePadding`. (defaults to 0)
  - `buttonSpacing`: spacing between each tab button
  - `sidePadding`: horizontal padding applied to the whole tab bar (left & right)

```swift
.tabBarLayoutConfig(buttonSpacing: 8, sidePadding: 12)
```

### indicatorStyle
- Customize Tab underline (indicator) with `.tabIndicatorStyle(...)`.
- You can set `height`, `color`, `horizontalInset`, `cornerRadius`, and `animationDuration`.

```swift
.tabIndicatorStyle(
    height: 2,
    color: .blue,
    horizontalInset: 8,
    cornerRadius: 4,
    animationDuration: 0.3
)
```

### isSwipeEnabled
- Enable or Disable Content Swipe
- Allow or disable swipe gesture to switch between tabs.
- Default is true. Use `.contentSwipeEnabled(false)` to disable swipe navigation.

```swift
.contentSwipeEnabled(false) // disables swipe gesture
```

### separatorStyle
- Adds a separator line between the TabBar and the content area.
- Use to visually distinguish the tab bar from page content.

```swift
.tabBarSeparator(
    color: .gray.opacity(0.2),
    height: 1,
    horizontalPadding: 0,
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
