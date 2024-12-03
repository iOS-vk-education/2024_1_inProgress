//
//  AddNewMoview.swift
//  VKino
//
//  Created by progeranna on 11/23/24.
//

import SwiftUI

// вынесла всё, вдруг придется юзать еще где-то
private enum Alerts {
    static let ERROR_TITLE: String = "Error"
    static let EMPTY_TITLE_MESSAGE: String = "Please fill in the movie title."
    static let EMPTY_IMAGE_MESSAGE: String = "Please upload the movie image."
    static let INVALID_RATING_MESSAGE: String = "Please enter a valid rating between 0 and 10."
    static let DELETE_CONFIRMATION_TITLE: String = "Delete Movie"
    static let DELETE_CONFIRMATION_MESSAGE: String = "Are you sure you want to delete this movie?"
    static let DELETE_BUTTON_TITLE: String = "Delete"
    static let CANCEL_BUTTON_TITLE: String = "Cancel"
    static let OK_BUTTON_TITLE: String = "OK"
}

struct AddMovieView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var searchViewModel: SearchViewModel
    @StateObject private var viewModel = AddMovieViewModel()

    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Dimensions.Spacing.NORMAL) {
                    MovieImagePreviewView(
                        imageData: $viewModel.movie.imageData,
                        showingImagePicker: $viewModel.showingImagePicker
                    )
                    MovieFormView(movie: $viewModel.movie)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.setShowingSearch(isShowing: true)
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                    }
                    Button(action: {
                        viewModel.saveMovie()
                        dismiss()
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.title2)
                            .foregroundColor(Colors.primaryButton)
                    }
                }
            }
            .sheet(isPresented: $viewModel.shouldShowSearchSheet) {
                SearchView(
                    searchViewModel: searchViewModel,
                    onMovieSelected: { selectedMovie in
                        viewModel.updateMovie(newMovie: selectedMovie)
                        viewModel.setShowingSearch(isShowing: false)
                    }) {
                    Spacer()
                }
            }
            .alert(Alerts.ERROR_TITLE, isPresented: $viewModel.showEmptyTitleAlert) {
                Button(Alerts.OK_BUTTON_TITLE, role: .cancel) { }
            } message: {
                Text(Alerts.EMPTY_TITLE_MESSAGE)
            }
            .alert(Alerts.ERROR_TITLE, isPresented: $viewModel.showEmptyImageAlert) {
                Button(Alerts.OK_BUTTON_TITLE, role: .cancel) { }
            } message: {
                Text(Alerts.EMPTY_IMAGE_MESSAGE)
            }
            .alert(Alerts.ERROR_TITLE, isPresented: $viewModel.showInvalidRatingAlert) {
                Button(Alerts.OK_BUTTON_TITLE, role: .cancel) { }
            } message: {
                Text(Alerts.INVALID_RATING_MESSAGE)
            }
            .alert(Alerts.DELETE_CONFIRMATION_TITLE, isPresented: $viewModel.showDeleteConfirmation) {
                deleteAlertActions
            } message: {
                Text(Alerts.DELETE_CONFIRMATION_MESSAGE)
            }

        }
    }

    private var deleteAlertActions: some View {
        Group {
            Button(Alerts.DELETE_BUTTON_TITLE, role: .destructive) {
                viewModel.deleteMovie()
            }
            Button(Alerts.CANCEL_BUTTON_TITLE, role: .cancel) {}
        }
    }

}
