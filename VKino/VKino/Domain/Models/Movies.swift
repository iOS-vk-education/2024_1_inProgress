//
//  Movies.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

struct Movies: Decodable {
    let docs: [MovieInfo]
    let total: Int
    let limit: Int
    let page: Int
    let pages: Int
}

struct MovieInfo: Decodable, Equatable, Hashable {
    let id: Int
    let name: String?
    let alternativeName: String?
    let type: String?
    let year: Int?
    let description: String?
    let shortDescription: String?
    let rating: Rating?
    let votes: Votes?
    let movieLength: Int?
    let poster: Poster?
    let genres: [Genre]?
    
    static func == (lhs: MovieInfo, rhs: MovieInfo) -> Bool {
           return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Poster: Decodable {
    let url: String?
    let previewUrl: String?
}

struct Rating: Decodable {
    let kp: Double?
    let imdb: Double?
    let filmCritics: Double?
    let russianFilmCritics: Double?
    let await: Double?
}

struct Votes: Decodable {
    let kp: Int
    let imdb: Int?
    let filmCritics: Int?
    let russianFilmCritics: Int?
    let await: Int?
}

struct Genre: Decodable {
    let name: String
}

struct Country: Decodable {
    let name: String
}

struct ReleaseYear: Decodable {
    let start: Int?
    let end: Int?
}
