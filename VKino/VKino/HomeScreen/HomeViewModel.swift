//
//  MainScreenViewModel.swift
//  VKino
//
//  Created by Konstantin on 21.11.2024.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    private var baseMovie: MovieInfo = MovieInfo(
        id: 0,
        name: "Stranger Things",
        alternativeName: "Stranger Things",
        type: nil,
        year: nil,
        description: nil,
        shortDescription: nil,
        rating: nil,
        votes: nil,
        movieLength: nil,
        poster: Poster(
            url: "https://resizing.flixster.com/0xxuABVVuzJrUT130WFHKE-irEg=/ems.cHJkLWVtcy1hc3NldHMvdHZzZWFzb24vNzUyMTFhOTktZTU4Ni00ODkyLWJlYjQtZTgxYTllZmU2OGM0LmpwZw==",
            previewUrl: nil
        ),
        genres: nil
    )

    @Published var savedMovies: [MovieInfo]

    init() {
        var movies: [MovieInfo] = []
        for index in 1...15 {
            movies.append(
                MovieInfo(
                    id: index,
                    name: baseMovie.name,
                    alternativeName: baseMovie.alternativeName,
                    type: baseMovie.type,
                    year: baseMovie.year,
                    description: baseMovie.description,
                    shortDescription: baseMovie.shortDescription,
                    rating: baseMovie.rating,
                    votes: baseMovie.votes,
                    movieLength: baseMovie.movieLength,
                    poster: baseMovie.poster,
                    genres: baseMovie.genres
                )
            )
        }
        
        self.savedMovies = movies
    }
}
