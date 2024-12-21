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
    case movieDetailsView(movie: Movie, source: MovieDetailsNavigationSource)
    case addMovieView(movie: Movie)
    case homeView
}

enum MovieDetailsNavigationSource: Hashable {
    case searchView
    case homeView
    case recomendationsView
}

enum AddMovieNavigationSource: Hashable {
    case movieDetailsView
    case tabBarView
}

enum SearchViewSource: Hashable {
    case homeView
    case addMovieView
}
