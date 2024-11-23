//
//  MovieFormView.swift
//  VKino
//
//  Created by progeranna on 11/23/24.
//

import SwiftUI

struct MovieFormView: View {
	@Binding var movie: Movie

	var body: some View {
		VStack(spacing: 12) {
			VStack {
				TextField("Title", text: $movie.title)
					.multilineTextAlignment(.center)
					.textFieldStyle(RoundedBorderTextFieldStyle())

				TextField("Original title", text: $movie.originalTitle)
					.multilineTextAlignment(.center)
					.font(.caption)
					.textFieldStyle(RoundedBorderTextFieldStyle())
			}

			Divider()

			VStack(spacing: 10) {
				HStack {
					Image(systemName: "books.vertical")
						.frame(width: 20)
					TextField("Category", text: $movie.category)
						.textFieldStyle(RoundedBorderTextFieldStyle())
				}

				HStack {
					Image(systemName: "clock")
						.frame(width: 20)
					TextField("Duration", text: $movie.duration)
						.textFieldStyle(RoundedBorderTextFieldStyle())
				}

				HStack {
					Image(systemName: "text.alignleft")
						.frame(width: 20)
					TextField("Description", text: $movie.description)
						.textFieldStyle(RoundedBorderTextFieldStyle())
				}

				HStack {
					Image(systemName: "person.3.sequence")
						.frame(width: 20)
					TextField("Actors", text: $movie.actors)
						.textFieldStyle(RoundedBorderTextFieldStyle())
				}

				HStack {
					Image(systemName: "person")
						.frame(width: 20)
					TextField("Author", text: $movie.author)
						.textFieldStyle(RoundedBorderTextFieldStyle())
				}
			}

			Button(action: {}) {
				Text("Save")
			}
		}
		.padding()
	}
}

#Preview {
	MovieFormView(movie: .constant(.init(title: "", originalTitle: "", category: "", duration: "", description: "", author: "", actors: "")))
}
