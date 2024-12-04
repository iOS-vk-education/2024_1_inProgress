//
//  VKinoApp.swift
//  VKino
//
//  Created by Xenia Yarunina on 18.11.2024.
//

import SwiftUI

@main
struct VKinoApp: App {
    @StateObject private var router = Router()
    @StateObject private var movieRepository = MovieRepository()

    var body: some Scene {
        WindowGroup {
            TabBar()
                .environmentObject(movieRepository)
                .environmentObject(router)
        }
    }
}
