//
//  MovieImagePreviewView.swift
//  VKino
//
//  Created by progeranna on 11/23/24.
//

import SwiftUI

struct MovieImagePreviewView: View {
    @Binding var imageData: Data?
    @Binding var showingImagePicker: Bool

    var body: some View {
        VStack {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: MovieImagePreviewConstants.IMAGE_HEIGHT)
                    .clipShape(RoundedRectangle(cornerRadius: MovieImagePreviewConstants.CORNER_RADIUS))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: MovieImagePreviewConstants.IMAGE_HEIGHT)
                    .foregroundColor(Colors.inputFieldIconColor)
            }

            Button(action: { showingImagePicker = true }) {
                Text(imageData == nil ? MovieImagePreviewConstants.ADD_IMAGE_TEXT : MovieImagePreviewConstants.CHANGE_IMAGE_TEXT)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(imageData: $imageData)
        }
    }

}

private enum MovieImagePreviewConstants {
    static let IMAGE_HEIGHT: CGFloat = 300.0
    static let CORNER_RADIUS: CGFloat = 10.0
    static let ADD_IMAGE_TEXT: String = "Add Image"
    static let CHANGE_IMAGE_TEXT: String = "Change Image"
}
