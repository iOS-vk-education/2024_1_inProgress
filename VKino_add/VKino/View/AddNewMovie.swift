//
//  AddNewMoview.swift
//  VKino
//
//  Created by - on 11/23/24.
//

import SwiftUI


struct AddNewMovie: View {
	@State private var showingSearch = false
	@State var showingImagePicker: Bool = false
	@State private var movie = Movie(
		title: "",
		originalTitle: "",
		category: "",
		duration: "",
		description: "",
		author: "",
		imageData: nil,
		actors: ""
	)

	var body: some View {
		ScrollView {
			VStack {
				Button("Search on Kinopoisk") {
					showingSearch = true
				}
				.sheet(isPresented: $showingSearch) {
					SearchKinopoiskView { selectedMovie in

						movie.title = selectedMovie.name ?? ""
						movie.description = selectedMovie.description ?? ""
						movie.duration = String(selectedMovie.movieLength ?? 0) + " мин."
						movie.category = selectedMovie.genres?.compactMap({$0.name}).joined(separator: ", ") ?? ""
						movie.originalTitle = (selectedMovie.names?.count ?? 0) > 1 ? selectedMovie.names?[1].name ?? "" : ""


						if let posterUrl = selectedMovie.poster?.url {
							downloadImage(from: posterUrl) { imageData in
								movie.imageData = imageData
							}
						}
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

#Preview {
	AddNewMovie()
}
