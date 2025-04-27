# TabPagerX

![Swift Version](https://img.shields.io/badge/Swift-5.5-orange.svg)
![Release Version](https://img.shields.io/badge/Release-1.0.7-blue.svg)
![SPM](https://img.shields.io/badge/SPM-compatible-green.svg)
![CocoaPods](https://img.shields.io/badge/CocoaPods-compatible-green.svg)

Effortless SwiftUI tab pager with dynamic customization.

`TabPagerX` is a SwiftUI-based library designed to help iOS developers create customizable tab pagers with ease.
It offers flexible layouts, tab scroll preservation, and extensive styling options for tab buttons and indicators, making it a perfect choice for building tab-based navigation in your SwiftUI applications.

## 💥 Features
- **Customizable Styles**: Tailor tab buttons and indicators with flexible styling.
- **Flexible Layouts**: Support for fixed or scrollable tab bars.
- **Scroll Preservation**: Keeps scroll positions when switching tabs.
- **Gesture Navigation**: Swipe to switch between tabs.
- **SwiftUI Support**: Built entirely with SwiftUI.

## 💥 Requirements

- iOS 15.0+
- Swift 5.5+
- Xcode 15.0+

## 💥 Usage


### Initialize TabPagerX

- Set up `TabPagerX` with `tabs` `selectedIndex`
- and optional `initialIndex` - Sets the initial tab on screen entry (defaults to 0)

```swift
@State private var tabs = ["Tab 1", "Tab 2", "Tab 3"]
@State private var selectedIndex = 0

TabPagerX(tabs: $tabs, selectedIndex: $selectedIndex, initialIndex: 1) { index in
    // Content goes here
}
```

### Add Content

- Define the content for each tab using the index.

```swift
TabPagerX(tabs: $tabs, selectedIndex: $selectedIndex) { index in
    Text("Content for \(tabs[index])")
}
```

### Set Tab Bar Layout Style

- Choose between `fixed` or `scrollable` layouts.

<table>
  <tr>
    <td>
      <pre><code>.tabBarLayoutStyle(.fixed)</code></pre>
      <img src="https://github.com/user-attachments/assets/f46c4860-08d8-4fcb-947b-87639c73446f" alt="Fixed Layout" width="400" height="auto">
    </td>
    <td>
      <pre><code>.tabBarLayoutStyle(.scrollable)</code></pre>
      <img src="https://github.com/user-attachments/assets/42a83bdd-4479-48e5-a63c-41aff9b75d4d" alt="Scrollable Layout" width="400" height="auto">
    </td>
  </tr>
</table>


### Configure Tab Bar Layout

- Adjust buttonSpacing and sidePadding. (defaults to 0)

```swift
.tabBarLayoutConfig(buttonSpacing: 8, sidePadding: 12)
```

### Customize Tab Button Style

- Style normal and selected states with ButtonStateStyle.
- If selected is omitted, normal style applies to both states.
- Customize padding, cornerRadius, and indicatorStyle.

```swift
.tabButtonStyle(
    normal: ButtonStateStyle(font: .body, textColor: .gray, backgroundColor: .white),
    selected: ButtonStateStyle(font: .headline, textColor: .blue, backgroundColor: .white),
    padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16),
    cornerRadius: 8,
    indicatorStyle: TabIndicatorStyle(height: 2, color: .blue, horizontalInset: 8, cornerRadius: 4, animationDuration: 0.3)
)
```


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


## 💥 License
`TabPagerX` is released under an MIT license. See [License](https://github.com/camosss/TabPagerX/blob/main/LICENSE) for more information.

