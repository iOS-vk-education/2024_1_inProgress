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
            SearchView(
                searchViewModel: searchViewModel,
                onMovieSelected: { movie in },
                source: .homeView
            ) {
                ScrollView {
                    // TODO: пофиксить верстку сетки
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: Dimensions.Spacing.xSmall),
                            GridItem(.flexible(), spacing: Dimensions.Spacing.xSmall)
                        ],
                        spacing: Dimensions.Spacing.normal
                    ) {
                        ForEach(viewModel.movies, id: \.id) { movie in
                            moviePreview(movie: movie) {
                                searchViewModel.searchText = ""
                                router.path.append(.movieDetailsView(movie: movie, source: .homeView))
                            }
                        }
                    }
                    .padding(.horizontal, Dimensions.Spacing.normal)
                }
            }
            .navigationDestination(for: MovieRoute.self) { route in
                switch route {
                case .movieDetailsView(let movie, let source):
                    MovieDetailsView(movie: movie, source: source, selectedTab: $selectedTab)
                case .addMovieView(let movie):
                    AddMovieView(
                        searchViewModel: searchViewModel,
                        movie: movie,
                        selectedTab: $selectedTab,
                        source: .movieDetailsView
                    )
                case .homeView:
                    HomeView(searchViewModel: searchViewModel, homeViewModel: viewModel, selectedTab: $selectedTab)
                }
            }
        }.onReceive(movieRepository.$movies) { movies in
            viewModel.movies = movies
        }
    }
}
