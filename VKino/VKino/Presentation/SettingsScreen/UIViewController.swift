//  UIViewController.swift
//  VKino
//
//  Created by progeranna  on 23.12.2024.
//

import UIKit
import SwiftUI

class SettingsViewController: UIViewController {

    @EnvironmentObject var movieRepository: MovieRepository

    // MARK: - UI Elements

    private let themeLabel: UILabel = {
        let label = UILabel()
        label.text = Alerts.theme
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let themeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: Alerts.lightTheme, at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: Alerts.darkTheme, at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: Alerts.systemTheme, at: 2, animated: false)
        segmentedControl.selectedSegmentIndex = 2
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private let languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let changeLanguageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Alerts.changeLanguageButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSettings()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = Alerts.settingsNavigationTitle

        view.addSubview(themeLabel)
        view.addSubview(themeSegmentedControl)
        view.addSubview(languageLabel)
        view.addSubview(changeLanguageButton)

        setupConstraints()

        themeSegmentedControl.addTarget(self, action: #selector(themeChanged(_:)), for: .valueChanged)
        changeLanguageButton.addTarget(self, action: #selector(changeLanguageTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            themeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            themeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            themeSegmentedControl.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 10),
            themeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            themeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            languageLabel.topAnchor.constraint(equalTo: themeSegmentedControl.bottomAnchor, constant: 40),
            languageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            changeLanguageButton.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 10),
            changeLanguageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    // MARK: - Actions

    @objc private func themeChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        UserDefaults.standard.set(selectedIndex, forKey: "SelectedTheme")
        applyTheme(selectedIndex: selectedIndex)
    }

    @objc private func changeLanguageTapped() {
        let alert = UIAlertController(
            title: Alerts.languageChangeTitle,
            message: Alerts.languageChangeMessage,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: Strings.cancelButton, style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: Strings.okButton, style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }))

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Helper Methods

    private func loadSettings() {
            if UserDefaults.standard.object(forKey: "SelectedTheme") == nil {
                themeSegmentedControl.selectedSegmentIndex = 2
                UserDefaults.standard.set(2, forKey: "SelectedTheme")
            } else {
                let selectedTheme = UserDefaults.standard.integer(forKey: "SelectedTheme")
                themeSegmentedControl.selectedSegmentIndex = selectedTheme
            }
            applyTheme(selectedIndex: themeSegmentedControl.selectedSegmentIndex)

        }

    private func applyTheme(selectedIndex: Int) {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let style: UIUserInterfaceStyle

        switch selectedIndex {
        case 0:
            style = .light
        case 1:
            style = .dark
        default:
            style = .unspecified
        }

        window.keyWindow?.overrideUserInterfaceStyle = style
    }

    // MARK: - constants

    private enum Alerts {
        static let theme = NSLocalizedString("Theme", comment: "")
        static let lightTheme = NSLocalizedString("Light", comment: "")
        static let darkTheme = NSLocalizedString("Dark", comment: "")
        static let systemTheme = NSLocalizedString("System", comment: "")

        static let changeLanguageButton = NSLocalizedString("ChangeLanguageButton", comment: "")

        static let settingsNavigationTitle = NSLocalizedString("SettingsNavigationTitle", comment: "")

        static let languageChangeTitle = NSLocalizedString("LanguageChangeTitle", comment: "")
        static let languageChangeMessage = NSLocalizedString("LanguageChangeMessage", comment: "")
    }

}

