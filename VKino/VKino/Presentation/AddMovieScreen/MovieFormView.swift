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
        VStack(spacing: Dimensions.Spacing.normal) {
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

            VStack(alignment: .leading, spacing: Dimensions.Spacing.normal) {
//                inputField(placeholder: "Enter category", text: $movie.category, systemImage: "books.vertical")
//                inputField(placeholder: "Enter duration", text: $movie.duration, systemImage: "clock")
//                inputField(placeholder: "Enter description", text: $movie.description, systemImage: "line.3.horizontal")
//                inputField(placeholder: "Enter actors", text: $movie.actors, systemImage: "person.3.sequence")
//                inputField(placeholder: "Enter author", text: $movie.author, systemImage: "person")
//                inputField(placeholder: "Enter rating", text: $movie.rating, systemImage: "star.fill", iconColor: .yellow)
                inputField(placeholder: NSLocalizedString("enter_category", comment: "Placeholder for category input"), text: $movie.category, systemImage: "books.vertical")
                inputField(placeholder: NSLocalizedString("enter_duration", comment: "Placeholder for duration input"), text: $movie.duration, systemImage: "clock")
                inputField(placeholder: NSLocalizedString("enter_description", comment: "Placeholder for description input"), text: $movie.description, systemImage: "line.3.horizontal")
                inputField(placeholder: NSLocalizedString("enter_actors", comment: "Placeholder for actors input"), text: $movie.actors, systemImage: "person.3.sequence")
                inputField(placeholder: NSLocalizedString("enter_author", comment: "Placeholder for author input"), text: $movie.author, systemImage: "person")
                inputField(placeholder: NSLocalizedString("enter_rating", comment: "Placeholder for rating input"), text: $movie.rating, systemImage: "star.fill", iconColor: .yellow)

            }
            .padding(.horizontal, Dimensions.Spacing.small)
        }
        .padding(Dimensions.Spacing.small)
    }

    private func inputField(
        placeholder: String,
        text: Binding<String>,
        systemImage: String,
        iconColor: Color = Colors.inputFieldIconColor
    ) -> some View {
        HStack(alignment: .center, spacing: Dimensions.Spacing.xSmall) {
            Image(systemName: systemImage)
                .frame(width: Dimensions.Spacing.iconSize, height: Dimensions.Spacing.iconSize)
                .foregroundColor(iconColor)

            VStack(alignment: .leading, spacing: Dimensions.Spacing.xxSmall) {
                TextField(placeholder, text: text)
                    .padding(Dimensions.Spacing.xxSmall)
                    .background(
                        RoundedRectangle(cornerRadius: Dimensions.CornerRadius.small)
                            .stroke(Colors.borderColor)
                    )
            }
        }
    }
}
