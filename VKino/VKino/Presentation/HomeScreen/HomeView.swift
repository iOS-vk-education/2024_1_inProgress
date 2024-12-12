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
                onMovieSelected: { movie in }
            ) {
                ScrollView {
                    // TODO: пофиксить верстку сетки
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: Dimensions.Spacing.X_SMALL),
                            GridItem(.flexible(), spacing: Dimensions.Spacing.X_SMALL)
                        ],
                        spacing: Dimensions.Spacing.NORMAL
                    ) {
                        ForEach(viewModel.movies, id: \.id) { movie in
                            moviePreview(movie: movie) {
                                searchViewModel.searchText = ""
                                router.path.append(.movieDetail(movie: movie, source: .homeView))
                            }
                        }
                    }
                    .padding(.horizontal, Dimensions.Spacing.NORMAL)
                }
            }
            .navigationDestination(for: MovieRoute.self) { route in
                switch route {
                case .movieDetail(let movie, let source):
                    MovieDetailsView(movie: movie, source: source, selectedTab: $selectedTab)
                case .addScreen(let movie):
                    AddMovieView(
                        searchViewModel: searchViewModel,
                        movie: movie,
                        selectedTab: $selectedTab,
                        source: .movieDetails
                    )
                case .mainScreen:
                    HomeView(searchViewModel: searchViewModel, homeViewModel: viewModel, selectedTab: $selectedTab)
                }
            }
        }.onReceive(movieRepository.$movies) { movies in
            viewModel.movies = movies
        }
    }
}

private extension HomeView {
    func moviePreview(movie: Movie, onTapGesture: @escaping () -> Void) -> some View {
        Group {
            if !movie.imageUrl.isEmpty {
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
            } else if let imageData = movie.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.NORMAL))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Colors.INPUT_FIELD_ICON_COLOR)
            }
        }
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
