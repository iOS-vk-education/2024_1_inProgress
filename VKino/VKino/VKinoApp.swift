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

    var body: some Scene {
        WindowGroup {
            TabBar()
                .environmentObject(router)
        }
    }
}
