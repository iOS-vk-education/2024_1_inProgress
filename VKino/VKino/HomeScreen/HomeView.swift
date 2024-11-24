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
    private let networkService: NetworkServiceProtocol

    @EnvironmentObject var router: Router

    @StateObject private var homeViewModel: HomeViewModel
    @State private var showCancelButton = false

    init(networkService: NetworkService, searchViewModel: SearchViewModel) {
        self.networkService = networkService
        self.searchViewModel = searchViewModel
        _homeViewModel  = StateObject(wrappedValue: HomeViewModel(networkService: networkService))
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            SearchView(
                searchViewModel: searchViewModel,
                onMovieSelected: { selectedMovie in }
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
                    .padding(.horizontal, Consts.Paddings.buttonPadding)
                }
            }.navigationDestination(for: MovieRoute.self) { route in
                switch route {
                case .movieDetail(let movie):
                    ContentView() // TODO: MovieDetailView(movie: movie, networkService: networkService)
                }
            }
        }
    }
}

// TODO: перенести рамеры в константы
enum Consts {
    enum Paddings {
        static let buttonPadding: CGFloat = 16
    }
}
