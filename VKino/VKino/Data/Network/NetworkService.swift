//
//  NetworkService.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func getBestMovies(page: Int) async throws -> Movies
    func getMovieDetails(id: Int) async throws -> MovieDetails
    func getSearchMovies(page: Int, name: String) async throws -> Movies
}

final class NetworkService: NetworkServiceProtocol {
    private func sendRequest<T: Decodable>(
           service: MoviesService,
           responseType: T.Type
       ) async throws -> T {
           
           guard var components = URLComponents(string: service.baseURL + service.path) else {
               throw NetworkError.invalidURL
           }
           
           if let parameters = service.parameters {
               components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
           }
           
           guard let url = components.url else {
               throw NetworkError.invalidURL
           }
           
           var request = URLRequest(url: url)
           request.httpMethod = service.method
           request.allHTTPHeaderFields = service.headers
           
           let (data, response) = try await URLSession.shared.data(for: request)
           
           guard let httpResponse = response as? HTTPURLResponse,
                 (200...299).contains(httpResponse.statusCode) else {
               throw NetworkError.invalidResponse
           }
           
           do {
               let decodedData = try JSONDecoder().decode(T.self, from: data)
               return decodedData
           } catch {
               throw NetworkError.decodingError
           }
       }
    
    // MARK: - Fetch movies
    func getBestMovies(page: Int) async throws -> Movies {
        return try await sendRequest(service: .bestMovies(page: page), responseType: Movies.self)
    }
        
    func getMovieDetails(id: Int) async throws -> MovieDetails {
        return try await sendRequest(service: .detailMovie(id: id), responseType: MovieDetails.self)
    }
    
    func getSearchMovies(page: Int, name: String) async throws -> Movies {
        return try await sendRequest(service: .searchMovies(page: page, name: name), responseType: Movies.self)
    }
}

// MARK: - Error
enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidResponse
    case decodingError
}
