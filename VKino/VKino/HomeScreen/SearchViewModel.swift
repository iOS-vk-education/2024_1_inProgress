//
//  SearchViewModel.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var movies: [MovieInfo] = []
    
    private var isLoading = false
    private var currentPage = 1

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        Task {
            await monitorSearchTextChanges()
        }
    }

    private func monitorSearchTextChanges() async {
        for await newText in $searchText.values {
            if !newText.isEmpty {
                resetPagination()
                await searchMovies(query: newText)
            }
        }
    }

    func searchMovies(query: String) async {
        guard !query.isEmpty, !isLoading else { return }
        
        isLoading = true
        
        do {
            let response = try await networkService.getSearchMovies(page: currentPage, name: query)
            movies.append(contentsOf: response.docs)
        } catch {
            // no - op
        }
        
        isLoading = false
    }

    private func resetPagination() {
        movies = []
    }
}
