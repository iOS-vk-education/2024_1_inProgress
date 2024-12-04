//
//  TabBar.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

import SwiftUI

struct TabBar: View {
    @State private var selectedTab: Tab = .home
    
    private let homeViewModel: HomeViewModel = HomeViewModel()

    enum Tab {
        case home
        case add
        case settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // TODO: one more tab with kinopoisk recomendations
            HomeView(
                searchViewModel: SearchViewModel(),
                homeViewModel: homeViewModel
            )
                .tabItem {
                    Image(systemName: "house.fill")
                        .renderingMode(.template)
                }
                .tag(Tab.home)

            AddMovieView(
                searchViewModel: SearchViewModel(),
                movie: Movie.emptyMovie()
            )
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
