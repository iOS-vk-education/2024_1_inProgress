//
//  SearchView.swift
//  VKino
//
//  Created by Konstantin on 24.11.2024.
//


import SwiftUI
import Kingfisher

struct SearchView<Content: View>: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @State private var showCancelButton = false
    @EnvironmentObject var router: Router

    let content: Content
    let onMovieSelected: (MovieInfo) -> Void
    
    init(searchViewModel: SearchViewModel, onMovieSelected: @escaping (MovieInfo) -> Void, @ViewBuilder content: () -> Content) {
        self.searchViewModel = searchViewModel
        self.content = content()
        self.onMovieSelected = onMovieSelected
    }
    
    var body: some View {
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
                                    onMovieSelected(movie)
                                    router.path.append(.movieDetail(movie: movie))
                                }
                        }
                    }
                }
            } else {
                content
            }
        }
        .padding(.top, 16)
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
