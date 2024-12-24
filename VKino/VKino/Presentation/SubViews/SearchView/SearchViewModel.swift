//
//  SearchViewModel.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

import Combine
import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var movies: [MovieInfo] = []
    
    private var isLoading = false
    private var currentPage = 1

    private var cancellables = Set<AnyCancellable>()
    private let networkService = NetworkService()

    init() {
        monitorSearchTextChanges()
    }

    private func monitorSearchTextChanges() {
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] newText in
                guard let self = self else { return }
                Task {
                    await self.handleSearchTextChange(newText)
                }
            }
            .store(in: &cancellables)
    }

    private func handleSearchTextChange(_ text: String) async {
        if !text.isEmpty {
            resetPagination()
            await searchMovies(query: text)
        }
    }

    private func searchMovies(query: String) async {
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
