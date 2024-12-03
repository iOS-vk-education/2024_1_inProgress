//
//  MovieDetailsView.swift
//  VKino
//
//  Created by Aleksandr Kaplenkov on 24.11.2024.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView: View {
    let movie: MovieInfo
    
    @StateObject private var viewModel: MovieDetailsViewModel
    @Environment(\.presentationMode) var presentationMode

    init(movie: MovieInfo) {
        self.movie = movie
        _viewModel = StateObject(wrappedValue: MovieDetailsViewModel())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Dimensions.Spacing.NORMAL) {
                movieHeaderView
                movieDetailsView
                if let rating = movie.rating, let votes = movie.votes {
                    ratingAndVotesView(rating: rating, votes: votes)
                }
                Spacer()
            }
        }
        .navigationTitle(movie.name ?? getString(name: "movie_details_title"))//"Movie Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            deleteButton
        }
        .alert(getString(name: "delete_alert_title"), isPresented: $viewModel.showDeleteConfirmation) {
            deleteAlertActions
        } message: {
            Text(getString(name: "delete_alert_message"))
        }
    }
}

private extension MovieDetailsView {
    var movieHeaderView: some View {
        ZStack(alignment: .bottomLeading) {
            KFImage(URL(string: movie.poster?.url ?? ""))
                .resizable()
                .scaledToFill()
                .frame(height: Const.Sizes.POSTER_HEIGHT)
                .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(Const.Other.GRADIENT_OPACITY), .clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: Const.Sizes.POSTER_HEIGHT)

            Text(movie.name ?? movie.alternativeName ?? getString(name: "movie_details_no_title"))
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
        }
    }

    var movieDetailsView: some View {
        VStack(alignment: .leading, spacing: Dimensions.Spacing.NORMAL) {
            if let genres = movie.genres, !genres.isEmpty {
                detailLabel(text: genres.map { $0.name }.joined(separator: ", "), systemImage: "info.circle")
            }
            
            if let movieLength = movie.movieLength {
                detailLabel(text: "\(movieLength) " + getString(name: "movie_details_time_units"), systemImage: "clock")
            }
            
            if let year = movie.year {
                detailLabel(text: "\(year)", systemImage: "calendar")
            }
            
            detailLabel(
                text: movie.description ?? movie.shortDescription ?? getString(name: "movie_details_no_description"),
                systemImage: "line.3.horizontal"
            )
        }
        .padding(.horizontal)
    }

    func ratingAndVotesView(rating: Rating, votes: Votes) -> some View {
        HStack(spacing: Dimensions.Spacing.NORMAL) {
            Label("\(String(format: getString(name: "movie_details_rating_format"), rating.kp ?? 0))", systemImage: "star.fill")
                .font(.headline)
                .foregroundColor(.yellow)

            Text("\(votes.kp) " + getString(name: "movie_details_votes"))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }

    var deleteButton: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            
            // TODO: here is gonna be logic behind passed movieType {FromSearch, FromMainScreen}
            Button {
                viewModel.onEditClicked()
            } label: {
                Image(systemName: "pencil")
                    .foregroundColor(.blue)
            }
            
            Button(role: .destructive) {
                viewModel.showDeleteConfirmation = true
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
    }

    var deleteAlertActions: some View {
        Group {
            Button(getString(name: "delete_button_label"), role: .destructive) {
                deleteMovie()
            }
            Button(getString(name: "cancel_button_label"), role: .cancel) {}
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
                .frame(width: Const.Sizes.ICON_SIZE, height: Const.Sizes.ICON_SIZE)
                .foregroundColor(.gray)
                .padding()
        }
    }
}

private extension MovieDetailsView {
    func deleteMovie() {
        // TODO: Make call to MovieService to delete it from Firebase
        presentationMode.wrappedValue.dismiss()
    }
}

private func getString(name: String) -> String {
    return NSLocalizedString(name, tableName: "AppStrings", comment: "")
}

private enum Const {
    enum Sizes {
        static let ICON_SIZE: CGFloat = 24
        static let POSTER_HEIGHT: CGFloat = 400
        static let GRADIENT_HEIGHT: CGFloat = 80
    }
    
    enum Other {
        static let GRADIENT_OPACITY: Double = 0.8
    }
}
