//
//  AddNewMoview.swift
//  VKino
//
//  Created by progeranna on 11/23/24.
//

import SwiftUI

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
                VStack(spacing: 16) {
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
                            .foregroundColor(.blue)
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
            .alert("Error", isPresented: $viewModel.showEmptyTitleAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please fill in the movie title.")
            }
            .alert("Error", isPresented: $viewModel.showEmptyImageAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please upload the movie image.")
            }
            .alert("Invalid Rating", isPresented: $viewModel.showInvalidRatingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid rating between 0 and 10.")
            }
            .alert("Delete Movie", isPresented: $viewModel.showDeleteConfirmation) {
                deleteAlertActions
            } message: {
                Text("Are you sure you want to delete this movie?")
            }
        }
    }

    private var deleteAlertActions: some View {
        Group {
            Button("Delete", role: .destructive) {
                viewModel.deleteMovie()
            }
            Button("Cancel", role: .cancel) {}
        }
    }

}
