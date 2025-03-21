import SwiftUI

struct TabBar: View {

    @Binding var tabs: [String]
    @Binding var selectedIndex: Int

    let layoutStyle: TabLayoutStyle

    var body: some View {

        switch layoutStyle {

        // Distributes tabs evenly across device width
        case .fixed:
            HStack(spacing: 0) {
                ForEach(tabs.indices, id: \.self) { index in
                    TabButton(
                        title: tabs[index],
                        isSelected: index == selectedIndex
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedIndex = index
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)

        // Adjusts tab size to content, enables horizontal scrolling
        case .scrollable:
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack(spacing: 0) {
                        ForEach(tabs.indices, id: \.self) { index in
                            TabButton(
                                title: tabs[index],
                                isSelected: index == selectedIndex
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedIndex = index
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 0)
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
