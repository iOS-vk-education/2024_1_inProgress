//
//  MainScreen.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    @ObservedObject private var searchViewModel: SearchViewModel
    @ObservedObject private var viewModel: HomeViewModel

    @EnvironmentObject var router: Router
    @EnvironmentObject var movieRepository: MovieRepository

    @State private var showCancelButton = false

    init(searchViewModel: SearchViewModel, homeViewModel: HomeViewModel) {
        self.searchViewModel = searchViewModel
        self.viewModel = homeViewModel
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            SearchView(
                searchViewModel: searchViewModel,
                onMovieSelected: { movie in }
            ) {
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: Dimensions.Spacing.X_SMALL),
                            GridItem(.flexible(), spacing: Dimensions.Spacing.X_SMALL)
                        ],
                        spacing: Dimensions.Spacing.NORMAL
                    ) {
                        ForEach(viewModel.movies, id: \.id) { movie in
                            moviePreview(movie: movie) {
                                router.path.append(.movieDetail(movie: movie, source: .movieList))
                            }
                        }
                    }
                    .padding(.horizontal, Dimensions.Spacing.NORMAL)
                }
            }
            .navigationDestination(for: MovieRoute.self) { route in
                switch route {
                case .movieDetail(let movie, let source):
                    MovieDetailsView(movie: movie, source: source, router: router)
                case .addScreen(let movie):
                    AddMovieView(searchViewModel: SearchViewModel(), movie: movie)
                }
            }
        }.onAppear {
            viewModel.setMovieRepository(repository: movieRepository)
        }
    }
}

private extension HomeView {
    func moviePreview(movie: Movie, onTapGesture: @escaping () -> Void) -> some View {
        KFImage(URL(string: movie.imageUrl))
            .resizable()
            .placeholder {
                ProgressView()
                    .frame(
                        width: Constants.HomeViewDesignSystem.MOVIE_PREVIEW_WIDTH,
                        height: Constants.HomeViewDesignSystem.MOVIE_PREVIEW_HEIGHT
                    )
            }
            .aspectRatio(contentMode: .fill)
            .frame(
                width: Constants.HomeViewDesignSystem.MOVIE_PREVIEW_WIDTH,
                height: Constants.HomeViewDesignSystem.MOVIE_PREVIEW_HEIGHT
            )
            .cornerRadius(Dimensions.CornerRadius.NORMAL)
            .onTapGesture {
                onTapGesture()
            }
    }
}


private enum Constants {
    enum HomeViewDesignSystem {
        static let MOVIE_PREVIEW_WIDTH: CGFloat = 171
        static let MOVIE_PREVIEW_HEIGHT: CGFloat = 245
    }
}
