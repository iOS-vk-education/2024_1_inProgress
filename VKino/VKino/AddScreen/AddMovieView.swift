//
//  AddNewMoview.swift
//  VKino
//
//  Created by progeranna on 11/23/24.
//

import SwiftUI


struct AddMovieView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var searchViewModel: SearchViewModel
    
    @State private var showingSearch = false
    @State var showingImagePicker: Bool = false
    @State private var movie = MovieEditable(
        id: 0,
        title: "",
        originalTitle: "",
        category: "",
        duration: "",
        description: "",
        author: "",
        imageData: nil,
        actors: ""
    )
    
    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Button("Search on Kinopoisk") {
                    showingSearch = true
                }
                .sheet(isPresented: $showingSearch) {
                    SearchView(
                        searchViewModel: searchViewModel,
                        onMovieSelected: { selectedMovie in

                            movie.title = selectedMovie.name ?? ""
                            movie.description = selectedMovie.description ?? ""
                            movie.duration = String(selectedMovie.movieLength ?? 0) + " мин."
                            movie.category = selectedMovie.genres?.compactMap({$0.name}).joined(separator: ", ") ?? ""
                            movie.originalTitle = selectedMovie.alternativeName ?? ""

                            if let posterUrl = selectedMovie.poster?.url {
                                downloadImage(from: posterUrl) { imageData in
                                    movie.imageData = imageData
                                }
                            }
                            // TODO: close sheet
                        }) {
                            Spacer()
                        }
                }
                MovieImagePreviewView(imageData: $movie.imageData, showingImagePicker: $showingImagePicker)
                MovieFormView(movie: $movie)
            }
        }
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
}
