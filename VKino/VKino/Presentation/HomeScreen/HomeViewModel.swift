//
//  MainScreenViewModel.swift
//  VKino
//
//  Created by Konstantin on 21.11.2024.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    private var movieRepository: MovieRepository? = nil

    @Published var movies: [Movie] = []

    func setMovieRepository(repository: MovieRepository) {
        self.movieRepository = repository
        self.subscribeToRepositoryMovies()
    }

    private func subscribeToRepositoryMovies() {
        movieRepository?.$movies
            .sink { [weak self] updatedMovies in
                self?.movies = updatedMovies
            }
    }
}
