//
//  AddMovieViewModel.swift
//  VKino
//
//  Created by Konstantin on 01.12.2024.
//

import SwiftUI

class AddMovieViewModel: ObservableObject {
    @Published var movie = Movie.emptyMovie()

    @Published var showingImagePicker = false
    @Published var shouldShowSearchSheet = false
    @Published var showDeleteConfirmation = false
    @Published var showEmptyTitleAlert = false
    @Published var showInvalidRatingAlert = false
    @Published var showEmptyImageAlert = false

    func updateMovie(newMovieInfo: MovieInfo) {
        movie = Movie.from(newMovieInfo)

        downloadImage(from: movie.imageUrl) { imageData in
            self.movie.imageData = imageData
        }
    }

    func saveMovie() {
        if movie.title.isEmpty {
            showEmptyTitleAlert = true
        } else if movie.imageData == nil {
            showEmptyImageAlert = true
        } else if !isValidRating(movie.rating) {
            showInvalidRatingAlert = true
        }
        else {
            // TODO: Реализация сохранения
            print("Movie saved")
        }
    }

    func deleteMovie() {
        // TODO: Реализация удаления
        print("Movie deleted")
    }

    func setShowingSearch(isShowing: Bool) {
        shouldShowSearchSheet = isShowing
    }

    private func downloadImage(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }

    private func isValidRating(_ rating: String) -> Bool {
        if rating.isEmpty {
            return true
        } else if let ratingValueInt = Int(rating) {
            if ratingValueInt >= 0 && ratingValueInt <= 10 {
                return true
            }
        }
        else if let ratingValue = Double(rating) {
            let formattedRating = String(format: "%.1f", ratingValue)
            if ratingValue >= 0 && ratingValue <= 10 && rating == formattedRating {
                return true
            }
        }
        
        return false
    }

}
