//
//  MovieDetailsViewModel.swift
//  VKino
//
//  Created by Aleksandr Kaplenkov on 03.12.2024.
//

import SwiftUI


class MovieDetailsViewModel: ObservableObject {
    private var movieRepository: MovieRepository? = nil
    @Published var movie: Movie

    @Published var showDeleteConfirmation = false

    init(movie newMovie: Movie) {
        self.movie = newMovie
    }

    func setMovieRepository(repository: MovieRepository) {
        self.movieRepository = repository
    }

    func deleteMovie() {
        DispatchQueue.main.async {
            self.movieRepository?.removeMovie(by: self.movie.id)
        }
    }

    func setDeletionConfirmation(status: Bool) {
        showDeleteConfirmation = status
    }

    func onEditClicked() {
        // TODO: implement bavigation to edit screen
    }

}
