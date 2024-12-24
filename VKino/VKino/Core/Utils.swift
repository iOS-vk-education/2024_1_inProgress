//
//  Utils.swift
//  VKino
//
//  Created by Konstantin on 21.11.2024.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

func downloadImage(from urlString: String, completion: @escaping (Data?) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, _, _ in
        DispatchQueue.main.async {
            completion(data)
        }
    }.resume()
}
