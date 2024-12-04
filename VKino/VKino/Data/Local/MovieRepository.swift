//
//  MovieRepository.swift
//  VKino
//
//  Created by Konstantin on 30.11.2024.
//

import Foundation
import Combine

class MovieRepository: ObservableObject {
    @Published private(set) var movies: [Movie] = []

    func addMovie(_ movie: Movie) {
        movies.append(movie)
    }

    func removeMovie(by id: UUID) {
        movies.removeAll { $0.id == id }
    }

    func updateMovie(_ updatedMovie: Movie) {
        guard let index = movies.firstIndex(where: { $0.id == updatedMovie.id }) else { return }
        movies[index] = updatedMovie
    }

    func findMovie(by id: UUID) -> Movie? {
        movies.first { $0.id == id }
    }
}
