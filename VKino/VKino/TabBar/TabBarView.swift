//
//  TabBar.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

import SwiftUI

struct TabBar: View {
    @State private var selectedTab: Tab = .home
    let networkService: NetworkService

    enum Tab {
        case home
        case add
        case settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            MainScreenView(networkService: networkService)
                .tabItem {
                    Image(systemName: "house.fill")
                        .renderingMode(.template)
                }
                .tag(Tab.home)

            ContentView() // TODO: DetailsView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                        .renderingMode(.template)
                }
                .tag(Tab.add)

            ContentView() // TODO: SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                        .renderingMode(.template)
                }
                .tag(Tab.settings)
        }
        .tabViewStyle(.automatic)
        .background(Color.white)
    }
}

#Preview {
    let networkService = NetworkService()
    TabBar(networkService: networkService)
}
