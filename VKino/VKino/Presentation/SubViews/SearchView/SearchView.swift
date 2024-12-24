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

    private let content: Content
    private let onMovieSelected: (MovieInfo) -> Void
    private var source: SearchViewSource

    init(
        searchViewModel: SearchViewModel,
        onMovieSelected: @escaping (MovieInfo) -> Void,
        source: SearchViewSource,
        @ViewBuilder content: () -> Content
    ) {
        self.searchViewModel = searchViewModel
        self.content = content()
        self.onMovieSelected = onMovieSelected
        self.source = source
    }

    var body: some View {
        VStack(spacing: Dimensions.Spacing.normal) {
            HStack {
                TextField("Search", text: $searchViewModel.searchText, onEditingChanged: { isEditing in
                    showCancelButton = isEditing || !searchViewModel.searchText.isEmpty
                })
                .padding(Dimensions.Spacing.xSmall)
                .padding(.horizontal, Dimensions.Spacing.xSmall)
                .background(Colors.textFieldBackgroundColor)
                .cornerRadius(Dimensions.CornerRadius.xLarge)
                
                if showCancelButton {
                    Button(Strings.cancelButton) {
                        searchViewModel.searchText = ""
                        showCancelButton = false
                        UIApplication.shared.endEditing()
                    }
                    .foregroundColor(Colors.primaryButtonColor)
                }
            }
            .padding(.horizontal, Dimensions.Spacing.normal)
            .frame(height: Constants.SearchViewDesignSystem.searchLineHeight)
            
            if !searchViewModel.searchText.isEmpty && !searchViewModel.movies.isEmpty {
                ScrollView {
                    LazyVStack {
                        ForEach(searchViewModel.movies, id: \.id) { movie in
                            MovieRow(movie: movie)
                                .padding(.horizontal, Dimensions.Spacing.normal)
                                .padding(.top,  Dimensions.Spacing.xSmall)
                                .onTapGesture {
                                    onMovieSelected(movie)
                                    if self.source == .homeView {
                                        router.path.append(.movieDetailsView(movie: Movie.from(movie), source: .searchView))
                                    }

                                }
                        }
                    }
                }
            } else {
                content
            }
        }
        .padding(.top, Dimensions.Spacing.normal)
        .onAppear {
            showCancelButton = false
            searchViewModel.searchText = ""
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
                        .frame(
                            width: Constants.SearchViewDesignSystem.moviePreviewWidth,
                            height: Constants.SearchViewDesignSystem.moviePreviewWidth
                        )
                }
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: Constants.SearchViewDesignSystem.moviePreviewWidth,
                    height: Constants.SearchViewDesignSystem.moviePreviewHeight
                )
                .cornerRadius(Dimensions.CornerRadius.normal)
            
            Text(movie.name ?? movie.alternativeName ?? "")
                .font(.headline)
                .padding(.leading, Dimensions.Spacing.normal)
            
            Spacer()

        }
        .frame(maxWidth: .infinity)
    }
}

private enum Constants {
    enum SearchViewDesignSystem {
        static let moviePreviewWidth: CGFloat = 60
        static let moviePreviewHeight: CGFloat = 90
        
        static let searchLineHeight: CGFloat = 36
    }
}
