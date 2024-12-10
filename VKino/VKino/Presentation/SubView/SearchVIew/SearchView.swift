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
        VStack(spacing: Dimensions.Spacing.NORMAL) {
            HStack {
                TextField("Search", text: $searchViewModel.searchText, onEditingChanged: { isEditing in
                    showCancelButton = isEditing || !searchViewModel.searchText.isEmpty
                })
                .padding(Dimensions.Spacing.X_SMALL)
                .padding(.horizontal, Dimensions.Spacing.X_SMALL)
                .background(Colors.TEXT_FIELD_BACKGROUND_COLOR)
                .cornerRadius(Dimensions.CornerRadius.X_LARGE)
                
                if showCancelButton {
                    Button("Cancel") {
                        searchViewModel.searchText = ""
                        showCancelButton = false
                        UIApplication.shared.endEditing()
                    }
                    .foregroundColor(Colors.PRIMARY_BUTTON_COLOR)
                }
            }
            .padding(.horizontal, Dimensions.Spacing.NORMAL)
            .frame(height: Constants.SearchViewDesignSystem.SEARCH_LINE_HEIGHT)
            
            if !searchViewModel.searchText.isEmpty && !searchViewModel.movies.isEmpty {
                ScrollView {
                    LazyVStack {
                        ForEach(searchViewModel.movies, id: \.id) { movie in
                            MovieRow(movie: movie)
                                .padding(.horizontal, Dimensions.Spacing.NORMAL)
                                .padding(.top,  Dimensions.Spacing.X_SMALL)
                                .onTapGesture {
                                    onMovieSelected(movie)
                                    router.path.append(.movieDetail(movie: Movie.from(movie), source: .search))
                                }
                        }
                    }
                }
            } else {
                content
            }
        }
        .padding(.top, Dimensions.Spacing.NORMAL)
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
                        .frame(
                            width: Constants.SearchViewDesignSystem.MOVIE_PREVIEW_WIDTH,
                            height: Constants.SearchViewDesignSystem.MOVIE_PREVIEW_WIDTH
                        )
                }
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: Constants.SearchViewDesignSystem.MOVIE_PREVIEW_WIDTH,
                    height: Constants.SearchViewDesignSystem.MOVIE_PREVIEW_HEIGHT
                )
                .cornerRadius(Dimensions.CornerRadius.NORMAL)
            
            Text(movie.name ?? movie.alternativeName ?? "")
                .font(.headline)
                .padding(.leading, Dimensions.Spacing.NORMAL)
            
            Spacer()

        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

private enum Constants {
    enum SearchViewDesignSystem {
        static let MOVIE_PREVIEW_WIDTH: CGFloat = 60
        static let MOVIE_PREVIEW_HEIGHT: CGFloat = 90
        
        static let SEARCH_LINE_HEIGHT: CGFloat = 36
    }
}
