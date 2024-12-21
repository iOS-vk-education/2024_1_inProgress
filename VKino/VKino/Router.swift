//
//  Router.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

import Foundation

class Router: ObservableObject {
    @Published var path = [MovieRoute]()
}

enum MovieRoute: Hashable {
    case movieDetail(movie: Movie, source: MovieDetailsNavigationSource)
    case addScreen(movie: Movie)
    case mainScreen
}

enum MovieDetailsNavigationSource: Hashable {
    case searchView
    case homeView
    case recomendationsView
}

enum AddMovieNavigationSource: Hashable {
    case movieDetails
    case tabBar
}
