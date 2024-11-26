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
        year: 2017,
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi venenatis tempor ipsum, sed pulvinar mi. Praesent accumsan, urna at bibendum facilisis, odio leo ultricies justo, et condimentum augue metus non urna. Vestibulum quis sagittis nisi, in tincidunt nisi. Sed a mauris semper, euismod ligula vitae, tempor ante. Nam eget venenatis felis, sed mollis odio. Suspendisse volutpat neque sem, eu egestas magna luctus vel. Vestibulum aliquet ac quam non pretium. Interdum et malesuada fames ac ante ipsum primis in faucibus. Pellentesque lobortis tortor sed ligula ornare, condimentum placerat ante volutpat. Aenean gravida quis tellus id vestibulum. Nulla varius enim ac hendrerit pulvinar. Integer neque arcu, tristique eget libero sit amet, semper pretium lectus.",
        shortDescription: nil,
        rating: nil,
        votes: nil,
        movieLength: 1000,
        poster: Poster(
            url: "https://resizing.flixster.com/0xxuABVVuzJrUT130WFHKE-irEg=/ems.cHJkLWVtcy1hc3NldHMvdHZzZWFzb24vNzUyMTFhOTktZTU4Ni00ODkyLWJlYjQtZTgxYTllZmU2OGM0LmpwZw==",
            previewUrl: nil
        ),
        genres: [Genre(name: "Horror"), Genre(name: "Drama"), Genre(name: "Mistery")]
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
