//
//  MovieDetailsView.swift
//  VKino
//
//  Created by Aleksandr Kaplenkov on 24.11.2024.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView: View {
    let movie: Movie
    
    @StateObject private var viewModel: MovieDetailsViewModel
    @Environment(\.presentationMode) var presentationMode

    init(movie: Movie) {
        self.movie = movie
        _viewModel = StateObject(wrappedValue: MovieDetailsViewModel())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Dimensions.Spacing.NORMAL) {
                movieHeaderView
                movieDetailsView
                if let votes = movie.votes {
                    ratingAndVotesView(rating: movie.rating, votes: votes)
                }
                Spacer()
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            deleteButton
        }
        .alert(getString("delete_alert_title"), isPresented: $viewModel.showDeleteConfirmation) {
            deleteAlertActions
        } message: {
            Text(getString("delete_alert_message"))
        }
    }
}

private extension MovieDetailsView {
    var movieHeaderView: some View {
        ZStack(alignment: .bottomLeading) {
            KFImage(URL(string: movie.imageUrl))
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

            Text(movie.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
        }
    }

    var movieDetailsView: some View {
        VStack(alignment: .leading, spacing: Dimensions.Spacing.NORMAL) {
            if !movie.category.isEmpty {
                detailLabel(text: movie.category, systemImage: "info.circle")
            }

            if !movie.duration.isEmpty {
                detailLabel(text: movie.duration, systemImage: "clock")
            }

            if !movie.year.isEmpty {
                detailLabel(text: movie.year, systemImage: "calendar")
            }

            detailLabel(text: movie.description, systemImage: "line.3.horizontal")
        }
        .padding(.horizontal)
    }

    func ratingAndVotesView(rating: String, votes: Votes) -> some View {
        HStack(spacing: Dimensions.Spacing.NORMAL) {
            Label(rating, systemImage: "star.fill")
                .font(.headline)
                .foregroundColor(.yellow)

            Text("\(votes.kp) " + getString("movie_details_votes"))
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
                viewModel.setDeletionConfirmation(status: true)
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
    }

    var deleteAlertActions: some View {
        Group {
            Button(getString("delete_button_label"), role: .destructive) {
                deleteMovie()
            }
            Button(getString("cancel_button_label"), role: .cancel) {}
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
