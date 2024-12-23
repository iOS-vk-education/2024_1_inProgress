//
//  AddNewMoview.swift
//  VKino
//
//  Created by progeranna on 11/23/24.
//

import SwiftUI

struct AddMovieView: View {
    @EnvironmentObject var movieRepository: MovieRepository
    @EnvironmentObject var router: Router

    @ObservedObject private var searchViewModel: SearchViewModel
    @StateObject private var viewModel: AddMovieViewModel
    @Binding private var selectedTab: TabBar.ScreenTab
    private var source: AddMovieNavigationSource

    init(
        searchViewModel: SearchViewModel,
        movie: Movie,
        selectedTab: Binding<TabBar.ScreenTab>,
        source: AddMovieNavigationSource
    ) {
        self.searchViewModel = searchViewModel
        _viewModel = StateObject(wrappedValue: AddMovieViewModel(movie: movie))
        self._selectedTab = selectedTab
        self.source = source
    }

    var body: some View {
        Group {
            if source == .tabBarView {
                NavigationView {
                    content
                        .navigationBarTitle("Добавить фильм", displayMode: .inline)
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                toolbarContent
                            }
                        }
                }
            } else {
                content
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            toolbarContent
                        }
                    }
            }
        }
        .onAppear {
            viewModel.setMovieRepository(repository: movieRepository)
        }
    }

    private var content: some View {
        ScrollView {
            VStack(spacing: Dimensions.Spacing.normal) {
                MovieImagePreviewView(
                    imageData: $viewModel.movie.imageData,
                    showingImagePicker: $viewModel.showingImagePicker
                )
                MovieFormView(movie: $viewModel.movie)
            }
        }
        .sheet(isPresented: $viewModel.shouldShowSearchSheet) {
            SearchView(
                searchViewModel: searchViewModel,
                onMovieSelected: { selectedMovie in
                    viewModel.updateMovie(newMovieInfo: selectedMovie)
                    viewModel.setShowingSearch(isShowing: false)
                },
                source: .addMovieView
            ) {
                Spacer()
            }
        }
        .alert(Alerts.errorTitle, isPresented: $viewModel.showEmptyTitleAlert) {
            Button(Alerts.okButtonTitle, role: .cancel) { }
        } message: {
            Text(Alerts.emptyTitleMessage)
        }
        .alert(Alerts.errorTitle, isPresented: $viewModel.showEmptyImageAlert) {
            Button(Alerts.okButtonTitle, role: .cancel) { }
        } message: {
            Text(Alerts.emptyImageMessage)
        }
        .alert(Alerts.errorTitle, isPresented: $viewModel.showInvalidRatingAlert) {
            Button(Alerts.okButtonTitle, role: .cancel) { }
        } message: {
            Text(Alerts.invalidRatingMessage)
        }
        .alert(Alerts.deleteConfirmationTitle, isPresented: $viewModel.showDeleteConfirmation) {
            deleteAlertActions
        } message: {
            Text(Alerts.deleteConfirmationMessage)
        }
    }

    private var toolbarContent: some View {
        Group {
            if source == .tabBarView {
                Button {
                    viewModel.setShowingSearch(isShowing: true)
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                }
            }
            Button(action: {
                saveMovie()
            }) {
                Image(systemName: "square.and.arrow.down")
                    .font(.title2)
                    .foregroundColor(Colors.primaryButtonColor)
            }
        }
    }

    private var deleteAlertActions: some View {
        Group {
            Button(Alerts.deleteButtonTitle, role: .destructive) {
                deleteMovie()
            }
            Button(Alerts.cancelButtonTitle, role: .cancel) {}
        }
    }
}

private extension AddMovieView {
    func deleteMovie() {
        viewModel.deleteMovie()
    }

    func saveMovie() {
        if source == .movieDetailsView {
            viewModel.editMovie {
                self.selectedTab = .home
                closeScreen(2)
            }
        } else {
            viewModel.saveMovie {
                self.selectedTab = .home
                closeScreen(1)
            }
        }
    }

    func closeScreen(_ n: Int) {
        for _ in 0..<n {
            if !router.path.isEmpty {
                self.router.path.removeLast()
            } else {
                break
            }
        }
    }
}

private enum Alerts {
    static let errorTitle: String = NSLocalizedString("errorTitle", comment: "Title for error alert")
    static let emptyTitleMessage: String = NSLocalizedString("emptyTitleMessage", comment: "Message for empty title")
    static let emptyImageMessage: String = NSLocalizedString("emptyImageMessage", comment: "Message for empty image")
    static let invalidRatingMessage: String = NSLocalizedString("invalidRatingMessage", comment: "Message for invalid rating")
    static let deleteConfirmationTitle: String = NSLocalizedString("deleteConfirmationTitle", comment: "Title for delete confirmation alert")
    static let deleteConfirmationMessage: String = NSLocalizedString("deleteConfirmationMessage", comment: "Message for delete confirmation alert")
    static let deleteButtonTitle: String = NSLocalizedString("deleteButtonTitle", comment: "Delete button title")
    static let cancelButtonTitle: String = NSLocalizedString("cancelButtonTitle", comment: "Cancel button title")
    static let okButtonTitle: String = NSLocalizedString("okButtonTitle", comment: "OK button title")
}
