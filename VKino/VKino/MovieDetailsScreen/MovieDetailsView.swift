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
    private let networkService: NetworkServiceProtocol
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showDeleteConfirmation = false

    init(movie: MovieInfo, networkService: NetworkServiceProtocol) {
        self.movie = movie
        self.networkService = networkService
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                movieHeaderView
                movieDetailsView
                if let rating = movie.rating, let votes = movie.votes {
                    ratingAndVotesView(rating: rating, votes: votes)
                }
                Spacer()
            }
        }
        .navigationTitle(movie.name ?? "Movie Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            deleteButton
        }
        .alert("Delete Movie", isPresented: $showDeleteConfirmation) {
            deleteAlertActions
        } message: {
            Text("Are you sure you want to delete this movie?")
        }
    }
}

private extension MovieDetailsView {
    var movieHeaderView: some View {
        ZStack(alignment: .bottomLeading) {
            KFImage(URL(string: movie.poster?.url ?? ""))
                .resizable()
                .scaledToFill()
                .frame(height: 400)
                .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.8), .clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 80)

            Text(movie.name ?? movie.alternativeName ?? "No Title")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
        }
    }

    var movieDetailsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let genres = movie.genres, !genres.isEmpty {
                detailLabel(text: genres.map { $0.name }.joined(separator: ", "), systemImage: "info.circle")
            }
            
            if let movieLength = movie.movieLength {
                detailLabel(text: "\(movieLength) мин.", systemImage: "clock")
            }
            
            if let year = movie.year {
                detailLabel(text: "\(year)", systemImage: "calendar")
            }
            
            detailLabel(
                text: movie.description ?? movie.shortDescription ?? "No description available.",
                systemImage: "line.3.horizontal"
            )
        }
        .padding(.horizontal)
    }

    func ratingAndVotesView(rating: Rating, votes: Votes) -> some View {
        HStack(spacing: 16) {
            Label("\(String(format: "%.1f", rating.kp ?? 0))", systemImage: "star.fill")
                .font(.headline)
                .foregroundColor(.yellow)

            Text("\(votes.kp) votes")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }

    var deleteButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Text("Delete")
                    .font(.body)
                    .foregroundColor(.blue)
            }
        }
    }

    var deleteAlertActions: some View {
        Group {
            Button("Delete", role: .destructive) {
                deleteMovie()
            }
            Button("Cancel", role: .cancel) {}
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
                .frame(width: 24, height: 24)
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
