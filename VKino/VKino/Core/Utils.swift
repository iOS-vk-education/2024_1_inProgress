//
//  Utils.swift
//  VKino
//
//  Created by Konstantin on 21.11.2024.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Movie {
    
    static func emptyMovie() -> Movie {
        return Movie(
            id: UUID(),
            title: "",
            originalTitle: "",
            category: "",
            year: "",
            duration: "",
            description: "",
            author: "",
            imageUrl: "",
            actors: "",
            rating: ""
        )
    }

    static func from(_ movieInfo: MovieInfo) -> Movie {
        return Movie(
            id: UUID(),
            title: movieInfo.name ?? movieInfo.alternativeName ?? NSLocalizedString("movie_details_title", comment: "Title for movie details"),
            originalTitle: movieInfo.alternativeName ?? "",
            category: movieInfo.genres?.compactMap({ $0.name }).joined(separator: ", ") ?? "",
            year: movieInfo.year.map { "\($0)" } ?? "",
            duration: movieInfo.movieLength.map { "\($0) " + NSLocalizedString("movie_details_time_units", comment: "Time units for movie duration") } ?? "",
            description: movieInfo.description ?? movieInfo.shortDescription ?? NSLocalizedString("movie_details_no_description", comment: "No description available"),
            author: "",
            imageUrl: movieInfo.poster?.url ?? movieInfo.poster?.previewUrl ?? "",
            actors: "",
            rating: String(format: NSLocalizedString("movie_details_rating_format", comment: "Format for movie rating"), (movieInfo.rating?.kp ?? movieInfo.rating?.imdb ?? movieInfo.rating?.filmCritics ?? movieInfo.rating?.russianFilmCritics ?? 0)),
            votes: movieInfo.votes
        )
    }
    
    static func updateMovie(_ movieInfo: MovieInfo, _ movieId: UUID) -> Movie {
        var newMovie = Movie.from(movieInfo)
        newMovie.id = movieId
        return newMovie
    }
    
}

func downloadImage(from urlString: String, completion: @escaping (Data?) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, _, _ in
        DispatchQueue.main.async {
            completion(data)
        }
    }.resume()
}
