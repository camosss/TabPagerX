import SwiftUI
import TabPagerX

struct TabPagerXSample: View {

    @State private var tabs = ["1", "2", "Tab 3"]
    @State private var selectedIndex = 0

    var body: some View {
        TabPagerX(
            tabs: $tabs,
            selectedIndex: $selectedIndex
        ) { index in
            List(0..<20) { item in
                Text("Item \(item) in \(tabs[index])")
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .tabBarLayoutStyle(.scrollable)
        .tabBarLayoutConfig(
            buttonSpacing: 8,
            sidePadding: 16
        )
        .tabButtonStyle(
            normal: ButtonStateStyle(font: .title3, textColor: .gray, backgroundColor: .white),
            selected: ButtonStateStyle(font: .title2, textColor: .blue, backgroundColor: .white),
            padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16),
            cornerRadius: 8,
            indicatorStyle: TabIndicatorStyle(height: 2, color: .blue, horizontalInset: 8, cornerRadius: 4, animationDuration: 0.3)
        )
    }
}
