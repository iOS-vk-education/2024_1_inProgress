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

    @EnvironmentObject var router: Router

    @StateObject private var homeViewModel: HomeViewModel
    @State private var showCancelButton = false

    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
        _homeViewModel  = StateObject(wrappedValue: HomeViewModel())
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
                            GridItem(.flexible(), spacing: 8),
                            GridItem(.flexible(), spacing: 8)
                        ],
                        spacing: 16
                    ) {
                        ForEach(homeViewModel.savedMovies, id: \.id) { movie in
                            KFImage(URL(string: movie.poster?.url ?? ""))
                                .resizable()
                                .placeholder {
                                    ProgressView()
                                        .frame(width: 171, height: 245)
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 171, height: 245)
                                .cornerRadius(6)
                                .onTapGesture {
                                    router.path.append(.movieDetail(movie: movie))
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }.navigationDestination(for: MovieRoute.self) { route in
                switch route {
                case .movieDetail(let movieInfo):
                    MovieDetailsView(movie: Movie.from(movieInfo))
                }
            }
        }
    }
}

