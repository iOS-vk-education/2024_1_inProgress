//
//  MovieList.swift
//  VKino
//
//  Created by Konstantin on 21.12.2024.
//
import SwiftUI
import Kingfisher

@MainActor
func moviePreview(movie: Movie, onTapGesture: @escaping () -> Void) -> some View {
    Group {
        if let imageData = movie.imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.normal))
        } else if !movie.imageUrl.isEmpty {
            KFImage(URL(string: movie.imageUrl))
                .resizable()
                .placeholder {
                    ProgressView()
                        .frame(
                            width: Constants.MoviePreview.moviePreviewWidth,
                            height: Constants.MoviePreview.moviePreviewHeight
                        )
                }
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: Constants.MoviePreview.moviePreviewWidth,
                    height: Constants.MoviePreview.moviePreviewHeight
                )
                .cornerRadius(Dimensions.CornerRadius.normal)
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .foregroundColor(Colors.inputFieldIconColor)
        }
    }.onTapGesture {
        onTapGesture()
    }
}

private enum Constants {
    enum MoviePreview {
        static let moviePreviewWidth: CGFloat = 171
        static let moviePreviewHeight: CGFloat = 245
    }
}
