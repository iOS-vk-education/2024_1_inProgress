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
        VStack(spacing: Dimensions.Spacing.NORMAL) { 
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

            VStack(alignment: .leading, spacing: Dimensions.Spacing.NORMAL) {
                inputField(placeholder: "Enter category", text: $movie.category, systemImage: "books.vertical")
                inputField(placeholder: "Enter duration", text: $movie.duration, systemImage: "clock")
                inputField(placeholder: "Enter description", text: $movie.description, systemImage: "line.3.horizontal")
                inputField(placeholder: "Enter actors", text: $movie.actors, systemImage: "person.3.sequence")
                inputField(placeholder: "Enter author", text: $movie.author, systemImage: "person")
                inputField(placeholder: "Enter rating", text: $movie.rating, systemImage: "star.fill", iconColor: .yellow)
            }
            .padding(.horizontal, Dimensions.Spacing.SMALL)
        }
        .padding(Dimensions.Spacing.SMALL)
    }

    private func inputField(
        placeholder: String,
        text: Binding<String>,
        systemImage: String,
        iconColor: Color = Colors.icon 
    ) -> some View {
        HStack(alignment: .center, spacing: Dimensions.Spacing.X_SMALL) {
            Image(systemName: systemImage)
                .frame(width: Dimensions.Spacing.ICON_SIZE, height: Dimensions.Spacing.ICON_SIZE)
                .foregroundColor(iconColor)

            VStack(alignment: .leading, spacing: Dimensions.Spacing.X_X_SMALL) {
                TextField(placeholder, text: text)
                    .padding(Dimensions.Spacing.X_X_SMALL)
                    .background(
                        RoundedRectangle(cornerRadius: Dimensions.CornerRadius.SMALL)
                            .stroke(Colors.border)
                    )
            }
        }
    }
}
