import SwiftUI

struct TabBar: View {

    @Binding var tabs: [String]
    @Binding var selectedIndex: Int

    let layoutStyle: TabLayoutStyle
    let layoutConfig: TabBarLayoutConfig
    let buttonStyle: TabButtonStyle
    let indicatorStyle: TabIndicatorStyle

    var body: some View {

        switch layoutStyle {

        // Distributes tabs evenly across device width
        case .fixed:
            HStack(spacing: layoutConfig.buttonSpacing) {
                ForEach(tabs.indices, id: \.self) { index in
                    TabButton(
                        title: tabs[index],
                        isSelected: index == selectedIndex,
                        buttonStyle: buttonStyle,
                        indicatorStyle: indicatorStyle
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedIndex = index
                        }
                    }
                }
            }
            .padding(.horizontal, layoutConfig.sidePadding)
            .frame(maxWidth: .infinity)

        // Adjusts tab size to content, enables horizontal scrolling
        case .scrollable:
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack(spacing: layoutConfig.buttonSpacing) {
                        ForEach(tabs.indices, id: \.self) { index in
                            TabButton(
                                title: tabs[index],
                                isSelected: index == selectedIndex,
                                buttonStyle: buttonStyle,
                                indicatorStyle: indicatorStyle
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedIndex = index
                                }
                            }
                        }
                    }
                    .padding(.horizontal, layoutConfig.sidePadding)
                    .onChange(of: selectedIndex) { newIndex in
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(newIndex, anchor: .center)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
