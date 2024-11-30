//
//  AddNewMoview.swift
//  VKino
//
//  Created by progeranna on 11/23/24.
//

import SwiftUI

class AddMovieViewModel: ObservableObject {
    @Published var movie = MovieEditable(
        id: 0,
        title: "",
        originalTitle: "",
        category: "",
        duration: "",
        description: "",
        author: "",
        imageData: nil,
        actors: "",
        rating: ""
    )
    
    @Published var showingImagePicker = false
    @Published var showingSearch = false
    @Published var showDeleteConfirmation = false
    @Published var showTitleEmptyAlert = false
    @Published var showInvalidRatingAlert = false

    func saveMovie() {
        if movie.title.isEmpty {
            showTitleEmptyAlert = true
        }
        else if !isValidRating(movie.rating) {
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

    func downloadImage(from urlString: String, completion: @escaping (Data?) -> Void) {
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
        if let ratingValueInt = Int(rating) {
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

struct AddMovieView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var searchViewModel: SearchViewModel
    @StateObject private var viewModel = AddMovieViewModel()

    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    MovieImagePreviewView(imageData: $viewModel.movie.imageData, showingImagePicker: $viewModel.showingImagePicker)
                    MovieFormView(movie: $viewModel.movie)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showingSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                    }
                    Button(action: {
                        viewModel.saveMovie()
                        dismiss()
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingSearch) {
                SearchView(
                    searchViewModel: searchViewModel,
                    onMovieSelected: { selectedMovie in
                        viewModel.movie.title = selectedMovie.name ?? ""
                        viewModel.movie.description = selectedMovie.description ?? ""
                        viewModel.movie.duration = String(selectedMovie.movieLength ?? 0) + " мин."
                        viewModel.movie.category = selectedMovie.genres?.compactMap({ $0.name }).joined(separator: ", ") ?? ""
                        viewModel.movie.originalTitle = selectedMovie.alternativeName ?? ""
                        viewModel.movie.rating = String(format: "%.1f", selectedMovie.rating?.kp ?? 0)

                        if let posterUrl = selectedMovie.poster?.url {
                            viewModel.downloadImage(from: posterUrl) { imageData in
                                viewModel.movie.imageData = imageData
                            }
                        }
                        viewModel.showingSearch = false
                    }) {
                    Spacer()
                }
            }
            .alert("Error", isPresented: $viewModel.showTitleEmptyAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please fill in the movie title.")
            }
            .alert("Invalid Rating", isPresented: $viewModel.showInvalidRatingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid rating between 0 and 10.")
            }
            .alert("Delete Movie", isPresented: $viewModel.showDeleteConfirmation) {
                deleteAlertActions
            } message: {
                Text("Are you sure you want to delete this movie?")
            }
        }
    }

    private var deleteAlertActions: some View {
        Group {
            Button("Delete", role: .destructive) {
                viewModel.deleteMovie()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
