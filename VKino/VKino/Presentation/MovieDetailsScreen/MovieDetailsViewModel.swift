//
//  MovieDetailsViewModel.swift
//  VKino
//
//  Created by Aleksandr Kaplenkov on 03.12.2024.
//

import SwiftUI
class MovieDetailsViewModel: ObservableObject {
    @Published var showDeleteConfirmation = false
    
    // TODO: need to add some sort of MovieRepository
    init() {
        
    }
    
    func deleteMovie(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
    
    func onEditClicked() {
        // TODO: implement bavigation to edit screen
    }
    
}
