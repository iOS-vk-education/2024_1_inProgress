//
//  MainScreenViewModel.swift
//  VKino
//
//  Created by Konstantin on 21.11.2024.
//

import SwiftUI
import Combine

class RecomendationsViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var currentPage = 1
    @Published var canLoadMorePages = true
    
    private let networkService = NetworkService()
    
    private var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
            await loadMovies()
        }
    }
    
    func loadMovies() async {
        guard !isLoading else { return }
        
        isLoading = true
        
        do {
            let response = try await networkService.getBestMovies(page: currentPage)
            movies.append(contentsOf: response.docs.map { Movie.from($0) })
            if response.docs.isEmpty {
                canLoadMorePages = false
            }
            currentPage += 1
        } catch {
            canLoadMorePages = false
        }
        
        isLoading = false
    }
}
