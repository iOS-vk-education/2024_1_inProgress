//
//  ImagePicker.swift
//  VKino
//
//  Created by progeranna on 11/23/24.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
	@Binding var imageData: Data?

	func makeUIViewController(context: Context) -> PHPickerViewController {
		var config = PHPickerConfiguration()
		config.selectionLimit = 1
		config.filter = .images

		let picker = PHPickerViewController(configuration: config)
		picker.delegate = context.coordinator
		return picker
	}

	func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	class Coordinator: NSObject, PHPickerViewControllerDelegate {
		let parent: ImagePicker

		init(_ parent: ImagePicker) {
			self.parent = parent
		}

		func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			picker.dismiss(animated: true)

			guard let provider = results.first?.itemProvider else { return }

			if provider.canLoadObject(ofClass: UIImage.self) {
				provider.loadObject(ofClass: UIImage.self) { image, _ in
					DispatchQueue.main.async {
						if let image = image as? UIImage {
							self.parent.imageData = image.jpegData(compressionQuality: 0.8)
						}
					}
				}
			}
		}
	}
}
