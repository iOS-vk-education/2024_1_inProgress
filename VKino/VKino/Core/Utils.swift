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
