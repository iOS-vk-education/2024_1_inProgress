//
//  MovieDetailsView.swift
//  VKino
//
//  Created by Aleksandr Kaplenkov on 24.11.2024.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var movieRepository: MovieRepository
    @EnvironmentObject var router: Router
    
    @StateObject private var viewModel: MovieDetailsViewModel
    @Binding private var selectedTab: TabBar.ScreenTab
    private var source: MovieDetailsNavigationSource

    init(
        movie: Movie,
        source: MovieDetailsNavigationSource,
        selectedTab: Binding<TabBar.ScreenTab>
    ) {
        _viewModel = StateObject(wrappedValue: MovieDetailsViewModel(movie: movie))
        self.source = source
        self._selectedTab = selectedTab
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Dimensions.Spacing.normal) {
                movieHeaderView
                movieDetailsView
                if let votes = viewModel.movie.votes {
                    ratingAndVotesView(rating: viewModel.movie.rating, votes: votes)
                }
                Spacer()
            }
        }
        .navigationTitle(viewModel.movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    onBackButtonPressed()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text(Strings.backButton)
                    }
                    .foregroundColor(.blue)
                }
            }
            toolbarButtons
        }
        .alert(Const.Strings.deleteAlertTitle, isPresented: $viewModel.showDeleteConfirmation) {
            deleteAlertActions
        } message: {
            Text(Const.Strings.deleteAlertMessage)
        }
        .onAppear {
            viewModel.setMovieRepository(repository: movieRepository)
        }
    }
}

private extension MovieDetailsView {
    var movieHeaderView: some View {
        ZStack(alignment: .bottomLeading) {
            moviePreview(movie: viewModel.movie, onTapGesture: {})
            Text(viewModel.movie.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
        }
    }

    var movieDetailsView: some View {
        VStack(alignment: .leading, spacing: Dimensions.Spacing.normal) {
            if !viewModel.movie.category.isEmpty {
                detailLabel(text: viewModel.movie.category, systemImage: "info.circle")
            }

            if !viewModel.movie.duration.isEmpty {
                detailLabel(text: viewModel.movie.duration, systemImage: "clock")
            }

            if !viewModel.movie.year.isEmpty {
                detailLabel(text: viewModel.movie.year, systemImage: "calendar")
            }

            if !viewModel.movie.description.isEmpty {
                detailLabel(text: viewModel.movie.description, systemImage: "line.3.horizontal")
            }
        }
        .padding(.horizontal)
    }

    func ratingAndVotesView(rating: String, votes: Votes) -> some View {
        HStack(spacing: Dimensions.Spacing.normal) {
            Label(rating, systemImage: "star.fill")
                .font(.headline)
                .foregroundColor(.yellow)

            Text("\(votes.kp) " + Const.Strings.movieDetailsVotes)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }

    var toolbarButtons: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            switch source {
            case .searchView, .recomendationsView:
                Button {
                    viewModel.onSaveClicked()
                    router.path.removeLast()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.blue)
                }
            case .homeView:
                Button(role: .destructive) {
                    viewModel.setDeletionConfirmation(status: true)
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            Button {
                router.path.append(.addMovieView(movie: viewModel.movie))
            } label: {
                Image(systemName: "pencil")
                    .foregroundColor(.blue)
            }
        }
    }

    var deleteAlertActions: some View {
        Group {
            Button(Strings.deleteButton, role: .destructive) {
                deleteMovie()
            }
            Button(Strings.cancelButton, role: .cancel) {}
        }
    }
}

private extension MovieDetailsView {
    func detailLabel(text: String, systemImage: String) -> some View {
        Label {
            Text(text)
                .font(.subheadline)
                .foregroundColor(.gray)
        } icon: {
            Image(systemName: systemImage)
                .resizable()
                .frame(width: Const.Sizes.iconSize, height: Const.Sizes.iconSize)
                .foregroundColor(.gray)
                .padding()
        }
    }
    
    func onBackButtonPressed() {
        movieRepository.fetchMovies()
        presentationMode.wrappedValue.dismiss()
    }
}

private extension MovieDetailsView {
    func deleteMovie() {
        viewModel.deleteMovie()
        presentationMode.wrappedValue.dismiss()
    }
}

private enum Const {
    enum Sizes {
        static let iconSize: CGFloat = 24
        static let posterHeight: CGFloat = 400
        static let gradientHeight: CGFloat = 80
    }
    
    enum Other {
        static let gradientOpacity: Double = 0.8
    }
    
    enum Strings {
        static let deleteAlertTitle = NSLocalizedString("delete_alert_title", comment: "Title for delete confirmation alert")
        static let deleteAlertMessage = NSLocalizedString("delete_alert_message", comment: "Message for delete confirmation alert")
        static let movieDetailsVotes = NSLocalizedString("movie_details_votes", comment: "Label for votes count")
    }
}
