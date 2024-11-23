//
//  SearchKinopoiskView.swift
//  VKino
//
//  Created by progeranna on 11/23/24.
//

import SwiftUI

struct SearchKinopoiskView: View {
	@Environment(\.dismiss) private var dismiss
	@State private var searchText = ""
	@State private var searchResults: [KinopoiskMovie] = []
	@State private var isLoading = false
	@State private var errorMessage: String?

	private let service = KinopoiskService()
	let onMovieSelect: (KinopoiskMovie) -> Void

	var body: some View {
		NavigationView {
			VStack {
				searchBar

				if isLoading {
					ProgressView()
						.frame(maxHeight: .infinity)
				} else if let error = errorMessage {
					Text(error)
						.foregroundColor(.red)
						.frame(maxHeight: .infinity)
				} else {
					resultsList
				}
			}
			.navigationTitle("Search Kinopoisk")
			.navigationBarItems(trailing: Button("Cancel") {
				dismiss()
			})
		}
	}

	private var searchBar: some View {
		HStack {
			TextField("Search movies...", text: $searchText)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.onChange(of: searchText) { newValue in
					searchDebounced(query: newValue)
				}

			if !searchText.isEmpty {
				Button(action: {
					searchText = ""
					searchResults = []
				}) {
					Image(systemName: "xmark.circle.fill")
						.foregroundColor(.gray)
				}
			}
		}
		.padding()
	}

	private var resultsList: some View {
		List(searchResults, id: \.id) { movie in
			MovieSearchResultRow(movie: movie)
				.onTapGesture {
					onMovieSelect(movie)
					dismiss()
				}
		}
	}

	private func searchDebounced(query: String) {
		guard !query.isEmpty else {
			searchResults = []
			return
		}

		isLoading = true
		errorMessage = nil

		Task {
			do {
				try await Task.sleep(nanoseconds: 750_000_000)
				let response = try await service.searchMovies(query: query)
				await MainActor.run {
					searchResults = response.docs
					isLoading = false
				}
			} catch {
				await MainActor.run {
					errorMessage = "Error searching movies: \(error.localizedDescription)"
					isLoading = false
				}
			}
		}
	}
}

struct MovieSearchResultRow: View {
	let movie: KinopoiskMovie

	var body: some View {
		HStack {
			if let posterUrl = movie.poster?.previewUrl,
			   let url = URL(string: posterUrl) {
				AsyncImage(url: url) { image in
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
				} placeholder: {
					Color.gray
				}
				.frame(width: 50, height: 75)
				.cornerRadius(8)
			} else {
				Color.gray
					.frame(width: 50, height: 75)
					.cornerRadius(8)
			}

			VStack(alignment: .leading, spacing: 4) {
				Text(movie.name ?? "Unknown")
					.font(.headline)

				if let year = movie.year {
					Text("Year: \(year)")
						.font(.subheadline)
						.foregroundColor(.gray)
				}

				if let rating = movie.rating?.kp {
					Text("Rating: \(String(format: "%.1f", rating))")
						.font(.subheadline)
						.foregroundColor(.gray)
				}
			}

			Spacer()
		}
		.padding(.vertical, 8)
	}
}

#Preview {
	SearchKinopoiskView(onMovieSelect: { _ in

	})
}
