//
//  MovieFormView.swift
//  VKino
//
//  Created by progeranna on 11/23/24.
//

import SwiftUI

struct MovieFormView: View {
    @Binding var movie: MovieEditable

    var body: some View {
        VStack(spacing: 16) {
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

            VStack(alignment: .leading, spacing: 16) {
                inputField(placeholder: "Enter category", text: $movie.category, systemImage: "books.vertical")
                inputField(placeholder: "Enter duration", text: $movie.duration, systemImage: "clock")
                inputField(placeholder: "Enter description", text: $movie.description, systemImage: "line.3.horizontal")
                inputField(placeholder: "Enter actors", text: $movie.actors, systemImage: "person.3.sequence")
                inputField(placeholder: "Enter author", text: $movie.author, systemImage: "person")
                inputField(placeholder: "Enter rating", text: $movie.rating, systemImage: "star.fill", iconColor: .yellow)
            }
            .padding(.horizontal)
        }
        .padding()
    }

    private func inputField(
        placeholder: String,
        text: Binding<String>,
        systemImage: String,
        iconColor: Color = .gray
    ) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: systemImage)
                .frame(width: 24, height: 24)
                .foregroundColor(iconColor)

            VStack(alignment: .leading, spacing: 4) {
                TextField(placeholder, text: text)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5))
                    )
            }
        }
    }

}
