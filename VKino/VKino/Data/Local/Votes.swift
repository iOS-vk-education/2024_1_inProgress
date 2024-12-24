//
//  Votes.swift
//  VKino
//
//  Created by Aleksandr Kaplenkov on 22.12.2024.
//

import SwiftData

@Model
final class LocalVotes {
    var kp: Int
    var imdb: Int?
    var filmCritics: Int?
    var russianFilmCritics: Int?
    var await: Int?

    init(kp: Int, imdb: Int? = nil, filmCritics: Int? = nil, russianFilmCritics: Int? = nil, awai: Int? = nil) {
        self.kp = kp
        self.imdb = imdb
        self.filmCritics = filmCritics
        self.russianFilmCritics = russianFilmCritics
        self.await = awai
    }
}

extension LocalVotes {
    public func toDomainVotes() -> Votes {
        return Votes(
            kp: self.kp,
            imdb: self.imdb,
            filmCritics: self.filmCritics,
            russianFilmCritics: self.russianFilmCritics,
            await: self.await
        )
    }
    
    public static func toLocalVotes(_ votes: Votes) -> LocalVotes {
        return LocalVotes(
            kp: votes.kp,
            imdb: votes.imdb,
            filmCritics: votes.filmCritics,
            russianFilmCritics: votes.russianFilmCritics,
            awai: votes.await
        )
    }
}
