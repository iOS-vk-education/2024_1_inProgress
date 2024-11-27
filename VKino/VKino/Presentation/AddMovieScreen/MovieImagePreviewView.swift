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
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .foregroundColor(.gray)
            }

            Button(action: { showingImagePicker = true }) {
                Text(imageData == nil ? "Add Image" : "Change Image")
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(imageData: $imageData)
        }
    }
}

#Preview {
    MovieImagePreviewView(imageData: .constant(nil), showingImagePicker: .constant(false))
}
