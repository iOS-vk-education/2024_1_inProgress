//
//  MainScreen.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    @StateObject private var searchViewModel: SearchViewModel
    @StateObject private var homeViewModel: HomeViewModel
    @EnvironmentObject var router: Router
    
    @State private var showCancelButton = false
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        _searchViewModel = StateObject(wrappedValue: SearchViewModel(networkService: networkService))
        _homeViewModel  = StateObject(wrappedValue: HomeViewModel(networkService: networkService))
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 16) {
                HStack {
                    TextField("Search", text: $searchViewModel.searchText, onEditingChanged: { isEditing in
                        showCancelButton = isEditing || !searchViewModel.searchText.isEmpty
                    })
                    .padding(8)
                    .padding(.horizontal, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    if showCancelButton {
                        Button("Cancel") {
                            searchViewModel.searchText = ""
                            showCancelButton = false
                            UIApplication.shared.endEditing()
                        }
                        .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 36)
                
                if !searchViewModel.searchText.isEmpty && !searchViewModel.movies.isEmpty {
                    ScrollView {
                        LazyVStack {
                            ForEach(searchViewModel.movies, id: \.id) { movie in
                                MovieRow(movie: movie)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 8)
                                    .onAppear {
                                        if movie == searchViewModel.movies.last {
                                            Task {
                                                await searchViewModel.searchMovies(query: searchViewModel.searchText)
                                            }
                                        }
                                    }
                                    .onTapGesture {
                                        router.path.append(.movieDetail(movie: movie))
                                    }
                            }
                        }
                    }
                } else {
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
                }
            }
            .padding(.top, 16)
            .navigationDestination(for: MovieRoute.self) { route in
                switch route {
                case .movieDetail(let movie):
                    ContentView() // TODO: MovieDetailView(movie: movie, networkService: networkService)
                }
            }
        }
    }
}

struct MovieRow: View {
    let movie: MovieInfo

    var body: some View {
        HStack {
            KFImage(URL(string: movie.poster?.url ?? ""))
                .resizable()
                .placeholder {
                    ProgressView()
                        .frame(width: 60, height: 60)
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 90)
                .cornerRadius(6)
            
            Text(movie.name ?? movie.alternativeName ?? "")
                .font(.headline)
                .padding(.leading, 16)
            
            Spacer()

        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}
