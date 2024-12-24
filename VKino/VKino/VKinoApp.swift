//
//  VKinoApp.swift
//  VKino
//
//  Created by Xenia Yarunina on 18.11.2024.
//

import SwiftUI
import SwiftData

@main
struct VKinoApp: App {
    private let container = try! ModelContainer(for: LocalMovie.self)
    private let repository: MovieRepository? = nil

    var body: some Scene {
        WindowGroup {
            if let a = try? ModelContainer(for: LocalMovie.self) {
                let movieRepository = MovieRepository(modelContainer: a)
                TabBar()
                    .environmentObject(movieRepository)
                    .modelContainer(a)
                    .onAppear { movieRepository.fetchMovies() }
            }
        }
    }
}
