//
//  KinopoiskService.swift
//  VKino
//
//  Created by progeranna on 11/23/24.
//


import Foundation

class KinopoiskService {
	private let apiKey = "MEB9PRD-XERM4W4-K9ET89Q-01GDMJG"
	private let baseURL = "https://api.kinopoisk.dev/v1.4"

	func searchMovies(query: String) async throws -> KinopoiskSearchResponse {
		var components = URLComponents(string: "\(baseURL)/movie/search")!
		components.queryItems = [
			URLQueryItem(name: "query", value: query),
			URLQueryItem(name: "limit", value: "10")
		]

		var request = URLRequest(url: components.url!)
		request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")

		let (data, _) = try await URLSession.shared.data(for: request)
		return try JSONDecoder().decode(KinopoiskSearchResponse.self, from: data)
	}

	func getMovieDetails(id: Int) async throws -> KinopoiskMovie {
		let url = URL(string: "\(baseURL)/movie/\(id)")!
		var request = URLRequest(url: url)
		request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")

		let (data, _) = try await URLSession.shared.data(for: request)
		return try JSONDecoder().decode(KinopoiskMovie.self, from: data)
	}
}
