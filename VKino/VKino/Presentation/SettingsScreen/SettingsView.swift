//
//  SettingsView.swift
//  VKino
//
//  Created by progeranna  on 23.12.2024.
//

import SwiftUI
import UIKit

struct SettingsView: UIViewControllerRepresentable {
    let repository: MovieRepository
    
    func makeUIViewController(context: Context) -> SettingsViewController {
        return SettingsViewController(movieRepository: repository)
    }

    func updateUIViewController(_ uiViewController: SettingsViewController, context: Context) {
    }
}
