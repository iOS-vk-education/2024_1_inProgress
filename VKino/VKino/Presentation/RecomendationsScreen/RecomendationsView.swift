//
//  MainScreen.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

import SwiftUI
import Kingfisher

struct RecomendationsView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var movieRepository: MovieRepository

    @ObservedObject private var searchViewModel: SearchViewModel
    @ObservedObject private var viewModel: RecomendationsViewModel
    @Binding private var selectedTab: TabBar.ScreenTab

    @State private var movies: [Movie] = []

    init(searchViewModel: SearchViewModel, recomendationsViewModel: RecomendationsViewModel, selectedTab: Binding<TabBar.ScreenTab>) {
        self.searchViewModel = searchViewModel
        self.viewModel = recomendationsViewModel
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
                    ForEach(viewModel.movies, id: \.id) { movie in
                        moviePreview(movie: movie) {
                            router.path.append(.movieDetailsView(movie: movie, source: .recomendationsView))
                        }.onAppear {
                            if movie == viewModel.movies.last {
                                Task {
                                    await viewModel.loadMovies()
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, Dimensions.Spacing.normal)
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
                default: Spacer()
                    // no - op
                }
            }
        }
    }
}
