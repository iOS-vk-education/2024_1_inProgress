//
//  TabBar.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

import SwiftUI

struct TabBar: View {
    @State private var selectedTab: ScreenTab = .home

    enum ScreenTab {
        case home
        case add
        case settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // TODO: one more tab with kinopoisk recomendations
            HomeView(
                searchViewModel: SearchViewModel(),
                homeViewModel: HomeViewModel(),
                selectedTab: $selectedTab
            )
                .tabItem {
                    Image(systemName: "house.fill")
                        .renderingMode(.template)
                }
                .tag(ScreenTab.home)

            AddMovieView(
                searchViewModel: SearchViewModel(),
                movie: Movie.emptyMovie(),
                selectedTab: $selectedTab,
                source: .tabBar
            )
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                        .renderingMode(.template)
                }
                .tag(ScreenTab.add)

            ContentView() // TODO: SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                        .renderingMode(.template)
                }
                .tag(ScreenTab.settings)
        }
        .tabViewStyle(.automatic)
        .background(Color.white)
    }
}
