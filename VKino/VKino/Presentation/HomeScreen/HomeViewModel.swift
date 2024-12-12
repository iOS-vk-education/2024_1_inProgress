//
//  MainScreenViewModel.swift
//  VKino
//
//  Created by Konstantin on 21.11.2024.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
}
