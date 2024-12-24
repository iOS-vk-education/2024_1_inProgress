//
//  LocalMovie.swift
//  VKino
//
//  Created by Aleksandr Kaplenkov on 22.12.2024.
//

import SwiftData
import Foundation

@Model
final class LocalMovie {
    @Attribute(.unique) var id: UUID
    var title: String
    var originalTitle: String
    var category: String
    var year: String
    var duration: String
    var desc: String
    var author: String
    var imageUrl: String
    var imageData: Data?
    var actors: String
    var rating: String
    var votes: LocalVotes?

    init(id: UUID = UUID(), title: String, originalTitle: String, category: String, year: String, duration: String, description: String, author: String, imageUrl: String, imageData: Data? = nil, actors: String, rating: String, votes: LocalVotes? = nil) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.category = category
        self.year = year
        self.duration = duration
        self.desc = description
        self.author = author
        self.imageUrl = imageUrl
        self.imageData = imageData
        self.actors = actors
        self.rating = rating
        self.votes = votes
    }
}

extension LocalMovie {
    public func toDomainMovie() -> Movie {
        return Movie(
            id: self.id,
            title: self.title,
            originalTitle: self.originalTitle,
            category: self.category,
            year: self.year,
            duration: self.duration,
            description: self.desc,
            author: self.author,
            imageUrl: self.imageUrl,
            imageData: self.imageData,
            actors: self.actors,
            rating: self.rating,
            votes: self.votes?.toDomainVotes()
        )
    }
    
    public static func fromDomainMovie(_ movie: Movie) -> LocalMovie {
        return LocalMovie(
            id: movie.id,
            title: movie.title,
            originalTitle: movie.originalTitle,
            category: movie.category,
            year: movie.year,
            duration: movie.duration,
            description: movie.description,
            author: movie.author,
            imageUrl: movie.imageUrl,
            imageData: movie.imageData,
            actors: movie.actors,
            rating: movie.rating,
            votes: movie.votes != nil ? LocalVotes.toLocalVotes(movie.votes!) : nil
        )
    }
            
}
