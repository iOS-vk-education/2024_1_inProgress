//  UIViewController.swift
//  VKino
//
//  Created by progeranna  on 23.12.2024.
//

import UIKit

class SettingsViewController: UIViewController {
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
        label.text = Alerts.selectLanguage
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let languageSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: Alerts.russian, at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: Alerts.english, at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private let isImplemented = false
//    private let isImplemented = true


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
        view.addSubview(languageSegmentedControl)

        setupConstraints()

        themeSegmentedControl.addTarget(self, action: #selector(themeChanged(_:)), for: .valueChanged)
        languageSegmentedControl.addTarget(self, action: #selector(languageChanged(_:)), for: .valueChanged)
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

            languageSegmentedControl.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 10),
            languageSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            languageSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // MARK: - Actions

    @objc private func themeChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        UserDefaults.standard.set(selectedIndex, forKey: "SelectedTheme")
        applyTheme(selectedIndex: selectedIndex)
    }

    @objc private func languageChanged(_ sender: UISegmentedControl) {
        if isImplemented {
            let currentLanguageIndex = languageSegmentedControl.selectedSegmentIndex
            let selectedLanguage = currentLanguageIndex == 0 ? "ru" : "en"

            let alert = UIAlertController(
                title: Alerts.languageChangeTitle,
                message: Alerts.languageChangeMessage,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: Alerts.cancel, style: .cancel, handler: { _ in
                let currentSelectedLanguage = UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String ?? "ru"
                self.languageSegmentedControl.selectedSegmentIndex = (currentSelectedLanguage == "ru") ? 0 : 1
            }))

            alert.addAction(UIAlertAction(title: Alerts.ok, style: .default, handler: { _ in
                UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                exit(0)
            }))

            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: Alerts.notice,
                message: Alerts.willBeImplementedLater,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: Alerts.ok, style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
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

            let selectedLanguage = UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String ?? "ru"
            languageSegmentedControl.selectedSegmentIndex = (selectedLanguage == "ru") ? 0 : 1
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

        static let selectLanguage = NSLocalizedString("SelectLanguage", comment: "")
        static let russian = NSLocalizedString("Russian", comment: "")
        static let english = NSLocalizedString("English", comment: "")

        static let settingsNavigationTitle = NSLocalizedString("SettingsNavigationTitle", comment: "")

        static let languageChangeTitle = NSLocalizedString("LanguageChangeTitle", comment: "")
        static let languageChangeMessage = NSLocalizedString("LanguageChangeMessage", comment: "")

        static let notice = NSLocalizedString("Notice", comment: "")
        static let willBeImplementedLater = NSLocalizedString("WillBeImplementedLater", comment: "")

        static let cancel = NSLocalizedString("Cancel", comment: "")
        static let ok = NSLocalizedString("OK", comment: "")
    }
}
