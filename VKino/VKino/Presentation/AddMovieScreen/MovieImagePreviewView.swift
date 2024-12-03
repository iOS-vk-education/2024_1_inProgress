//
//  MovieImagePreviewView.swift
//  VKino
//
//  Created by progeranna on 11/23/24.
//

import SwiftUI

private enum MovieImagePreviewConstants {
    static let imageHeight: CGFloat = 300.0
    static let cornerRadius: CGFloat = 10.0
    // аналогично вдруг еще заюзать придется
    static let addImageText: String = "Add Image"
    static let changeImageText: String = "Change Image"
}

struct MovieImagePreviewView: View {
    @Binding var imageData: Data?
    @Binding var showingImagePicker: Bool

    var body: some View {
        VStack {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: MovieImagePreviewConstants.imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: MovieImagePreviewConstants.cornerRadius))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: MovieImagePreviewConstants.imageHeight)
                    .foregroundColor(Colors.icon)
            }

            Button(action: { showingImagePicker = true }) {
                Text(imageData == nil ? MovieImagePreviewConstants.addImageText : MovieImagePreviewConstants.changeImageText)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(imageData: $imageData)
        }
    }

}
