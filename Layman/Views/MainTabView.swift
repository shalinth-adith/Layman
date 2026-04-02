import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var tabBarState = TabBarState()

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0: HomeView()
                case 1: SavedView()
                case 2: ProfileView()
                default: HomeView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .environmentObject(tabBarState)

            // Custom tab bar
            if !tabBarState.isHidden {
            HStack(spacing: 0) {
                tabItem(icon: "house.fill", label: "Home", index: 0)
                tabItem(icon: "bookmark.fill", label: "Saved", index: 1)
                tabItem(icon: "person.circle.fill", label: "Profile", index: 2)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: -2)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            } // end if
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private func tabItem(icon: String, label: String, index: Int) -> some View {
        Button {
            selectedTab = index
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .appFont(size: 22, weight: .semibold)
                    .foregroundColor(selectedTab == index ? AppTheme.accentOrange : Color.gray.opacity(0.5))
                Text(label)
                    .appFont(size: 11, weight: .medium)
                    .foregroundColor(selectedTab == index ? AppTheme.accentOrange : Color.gray.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainTabView()
}
