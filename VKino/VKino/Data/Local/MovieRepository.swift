//
//  MovieRepository.swift
//  VKino
//
//  Created by Konstantin on 30.11.2024.
//

import Foundation
import Combine
import SwiftData

class MovieRepository: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    private var modelContext: ModelContext
    private var desc = FetchDescriptor<LocalMovie>()
    private var container: ModelContainer
    
    @MainActor init(modelContainer: ModelContainer) {
        self.container = modelContainer
        self.modelContext = modelContainer.mainContext
    }

    func addMovie(_ movie: Movie) {
        let a = LocalMovie.fromDomainMovie(movie)
        modelContext.insert(a)
        saveContext()
        fetchMovies()
    }

    func removeMovie(by id: UUID) {
        do {
            let allMovies = try modelContext.fetch(desc)
            if let movieToDelete = allMovies.first(where: { $0.id == id }) {
                modelContext.delete(movieToDelete)
                saveContext()
                fetchMovies()
            }
        } catch {
            print("Error fetching movies: \(error.localizedDescription)")
            /* does nothing */
        }
    }

    func updateMovie(_ updatedMovie: Movie) {
        removeMovie(by: updatedMovie.id)
        addMovie(updatedMovie)
    }

    func findMovie(by id: UUID) -> Movie? {
        movies.first { $0.id == id }
    }
    
    func fetchMovies() {
        do {
            let allMovies = try modelContext.fetch(desc)
            movies = allMovies.map { $0.toDomainMovie() }
        } catch {
            print("Error fetching movies: \(error.localizedDescription)")
            /* does nothing */
        }
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Didn't saved context of bd")
            /* does nothing */
        }
    }
}
