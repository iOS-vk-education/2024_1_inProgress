//
//  Views.swift
//  VKino
//
//  Created by Konstantin on 24.11.2024.
//

import SwiftUI

struct MovieSearchResultRow: View {
    let movie: MovieInfo

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
