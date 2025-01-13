//
//  MainScreen.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var movieRepository: MovieRepository

    @ObservedObject private var searchViewModel: SearchViewModel
    @ObservedObject private var viewModel: HomeViewModel
    @Binding private var selectedTab: TabBar.ScreenTab

    @State private var showCancelButton = false
    @State private var movies: [Movie] = []

    init(searchViewModel: SearchViewModel, homeViewModel: HomeViewModel, selectedTab: Binding<TabBar.ScreenTab>) {
        self.searchViewModel = searchViewModel
        self.viewModel = homeViewModel
        self._selectedTab = selectedTab
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: Dimensions.Spacing.xSmall),
                        GridItem(.flexible(), spacing: Dimensions.Spacing.xSmall)
                    ],
                    spacing: Dimensions.Spacing.normal
                ) {
                    ForEach(movies, id: \.id) { movie in
                        ZStack {
                            RoundedRectangle(cornerRadius:  Dimensions.CornerRadius.xxLarge)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color(.systemFill), radius: Dimensions.CornerRadius.large, x: 0, y: 4)
                            moviePreview(movie: movie) {
                                searchViewModel.searchText = ""
                                router.path.append(.movieDetailsView(movie: movie, source: .homeView))
                            }
                            .padding(Dimensions.Spacing.xSmall)
                        }
                        .padding(.horizontal, Dimensions.Spacing.xSmall)
                        
                    }
                }
                .padding(.horizontal, Dimensions.Spacing.normal)
            }
            .navigationDestination(for: MovieRoute.self) { route in
                switch route {
                case .movieDetailsView(let movie, let source):
                    MovieDetailsView(movie: movie, source: source, selectedTab: $selectedTab)
                    
                default: Spacer()
                }
            }
        }.onReceive(movieRepository.$movies) { movies in
            self.movies = movies
        }
    }
}
