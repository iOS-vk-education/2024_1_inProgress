//
//  MainScreen.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

import SwiftUI
import Kingfisher

struct MainScreenView: View {
    @StateObject private var viewModel: SearchViewModel
    @EnvironmentObject var router: Router
    
    @State private var showCancelButton = false
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        _viewModel = StateObject(wrappedValue: SearchViewModel(networkService: networkService))
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 16) {
                HStack {
                    TextField("Search", text: $viewModel.searchText, onEditingChanged: { isEditing in
                        showCancelButton = isEditing || !viewModel.searchText.isEmpty
                    })
                    .padding(8)
                    .padding(.horizontal, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                    if showCancelButton {
                        Button("Cancel") {
                            viewModel.searchText = ""
                            showCancelButton = false
                            UIApplication.shared.endEditing()
                        }
                        .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 36)
                
                if !viewModel.searchText.isEmpty && !viewModel.movies.isEmpty {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.movies, id: \.id) { movie in
                                MovieRow(movie: movie)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 8)
                                    .onAppear {
                                        if movie == viewModel.movies.last {
                                            Task {
                                                await viewModel.searchMovies(query: viewModel.searchText)
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
                    Spacer()
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
