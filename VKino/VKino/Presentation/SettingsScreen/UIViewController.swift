//
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
        label.text = NSLocalizedString("ChangeTheme", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let themeSwitch: UISwitch = {
        let themeSwitch = UISwitch()
        themeSwitch.translatesAutoresizingMaskIntoConstraints = false
        return themeSwitch
    }()

    private let languageLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("SelectLanguage", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let languageSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: NSLocalizedString("Russian", comment: ""), at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: NSLocalizedString("English", comment: ""), at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
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
        title = NSLocalizedString("SettingsNavigationTitle", comment: "")

        view.addSubview(themeLabel)
        view.addSubview(themeSwitch)
        view.addSubview(languageLabel)
        view.addSubview(languageSegmentedControl)

        setupConstraints()

        themeSwitch.addTarget(self, action: #selector(themeSwitchChanged(_:)), for: .valueChanged)
        languageSegmentedControl.addTarget(self, action: #selector(languageChanged(_:)), for: .valueChanged)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            themeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            themeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            themeSwitch.centerYAnchor.constraint(equalTo: themeLabel.centerYAnchor),
            themeSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            languageLabel.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 40),
            languageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            languageSegmentedControl.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 10),
            languageSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            languageSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // MARK: - Actions

    @objc private func themeSwitchChanged(_ sender: UISwitch) {
        let isDarkMode = sender.isOn
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        updateAppearance()
    }

    @objc private func languageChanged(_ sender: UISegmentedControl) {
        let currentLanguageIndex = languageSegmentedControl.selectedSegmentIndex
        let selectedLanguage = currentLanguageIndex == 0 ? "ru" : "en"

        let alert = UIAlertController(
            title: NSLocalizedString("LanguageChangeTitle", comment: ""),
            message: NSLocalizedString("LanguageChangeMessage", comment: ""),
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
            let currentSelectedLanguage = UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String ?? "ru"
            self.languageSegmentedControl.selectedSegmentIndex = (currentSelectedLanguage == "ru") ? 0 : 1
        }))

        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            exit(0)
        }))

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Helper Methods

    private func loadSettings() {
        // Приложение всегда запускается в светлой теме
        UserDefaults.standard.set(false, forKey: "isDarkMode")
        themeSwitch.isOn = false
        updateAppearance()

        let selectedLanguage = UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String ?? "ru"
        languageSegmentedControl.selectedSegmentIndex = (selectedLanguage == "ru") ? 0 : 1
    }

    private func updateAppearance() {
        if let window = UIApplication.shared.windows.first {
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
            window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }
}
