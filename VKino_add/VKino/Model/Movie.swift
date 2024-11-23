//
//  Movie.swift
//  VKino
//
//  Created by progeranna on 11/23/24.
//

import Foundation


struct Movie: Identifiable {
	let id = UUID()
	var title: String
	var originalTitle: String
	var category: String
	var duration: String
	var description: String
	var author: String
	var imageData: Data?
	var actors: String
}

struct Genre: Codable {
	let name: String
}

struct AlternateName: Codable {
	let name: String
}

struct KinopoiskMovie: Codable {
	let id: Int
	let name: String?
	let description: String?
	let type: String?
	let year: Int?
	let rating: Rating?
	let poster: ShortImage?
	let movieLength: Int?
	let genres: [Genre]?
	let names: [AlternateName]?

	struct Rating: Codable {
		let kp: Double?
		let imdb: Double?
	}

	struct ShortImage: Codable {
		let url: String?
		let previewUrl: String?
	}
}

struct KinopoiskSearchResponse: Codable {
	let docs: [KinopoiskMovie]
	let total: Int
	let limit: Int
	let page: Int
	let pages: Int
}
