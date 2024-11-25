//
//  MoviesService.swift
//  VKino
//
//  Created by Konstantin on 20.11.2024.
//

import Foundation

struct APIConstants {
    static let apiKey = "1JCWXT8-MDTMG3P-QA53W8Y-347C1D0"
}

protocol MovieServiceProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String] { get }
}

enum MoviesService: MovieServiceProtocol {
    case bestMovies(page: Int)
    case searchMovies(page: Int, name: String)
    case detailMovie(id: Int)

    var baseURL: String {
        return "https://api.kinopoisk.dev/v1.4"
    }
    
    var path: String {
        switch self {
        case .bestMovies:
            "/movie"
        case .detailMovie(let id):
            "/movie/\(id)"
        case .searchMovies:
            "/movie/search"
        }
    }
    
    var method: String {
        return "GET"
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .bestMovies(let page):
            return [
                "field": "typeNumber",
                 "search": "1",
                 "sortField": "votes.kp",
                 "sortType": "-1",
                "limit": "20",
                "page": "\(page)"
            ]
            
        case .searchMovies(let page, let name):
            return [
                "page": "\(page)",
                "limit": "20",
                "query": "\(name)",
            ]
            
        case .detailMovie(_):
            return nil
        }
    }
    
    var headers: [String: String] {
        return [
            "X-API-KEY": APIConstants.apiKey,
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
