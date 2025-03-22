import SwiftUI

struct ContentView: View {

    @State private var tabs = ["Tab 1", "Tab 2", "Tab 3"]
    @State private var selectedIndex = 0

    var body: some View {
        TabPager(
            tabs: $tabs,
            selectedIndex: $selectedIndex
        ) { index in
            Text("\(tabs[index])")
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
        }
        .tabBarLayoutStyle(.scrollable)
        .tabBarLayoutConfig(
            buttonSpacing: 8,
            sidePadding: 12
        )
        .tabButtonStyle(
            normal: ButtonStateStyle(
                font: .title3,
                textColor: .gray,
                backgroundColor: .white
            ),
            selected: ButtonStateStyle(
                font: .title2,
                textColor: .blue,
                backgroundColor: .white
            ),
            padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16),
            indicatorStyle: TabIndicatorStyle(
                height: 2,
                color: .blue,
                horizontalInset: 8,
                cornerRadius: 4
            )
        )
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
