//
// MainViewController+UI.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import ChatCenterUI
import SwiftUI
import UIKit

/// Настройки UI
extension MainViewController {
    func setupUI() {
        view.backgroundColor = .secondarySystemBackground

        setupNavigationBar()
        setupImage()
        setupTitleLabel()
        setupSelectedServerButton()
        setupSelectedUserButton()
        setupMainButton()
        setupDemoButton()
        setupInfoLabel()
    }

    func setupNavigationBar() {
        let settingsIcon = UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(pointSize: 19))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: settingsIcon, primaryAction: UIAction(handler: { [weak self] _ in
            guard let self else {
                return
            }

            let controller = UIHostingController(rootView: SettingsView())
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            controller.view.backgroundColor = .clear
            present(controller, animated: true)
        }))

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "theme_icon"), primaryAction: UIAction(handler: { [weak self] _ in
            let style: UIUserInterfaceStyle = self?.traitCollection.userInterfaceStyle == .dark ? .light : .dark
            for window in UIApplication.shared.windows {
                window.overrideUserInterfaceStyle = style
            }
        }))
    }

    func setupImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 185),
            imageView.heightAnchor.constraint(equalToConstant: 185),
            imageView.centerXAnchor.constraint(equalTo: view.safeArea.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeArea.topAnchor, constant: 58),
        ])

        guard
            let gifPath = Bundle.main.path(forResource: "logo", ofType: "gif"),
            let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)),
            let gifImage = UIImage.gifImageWithData(gifData)
        else {
            return
        }

        imageView.image = gifImage
    }

    func setupTitleLabel() {
        titleLabel.text = "Вход в аккаунт"
        titleLabel.font = .systemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeArea.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeArea.trailingAnchor, constant: -24),
        ])
    }

    func setupSelectedServerButton() {
        selectServerButton.setActiveDesign()
        selectServerButton.setup()
        selectServerButton.setTitle("Сервер", for: .normal)
        selectServerButton.translatesAutoresizingMaskIntoConstraints = false
        selectServerButton.addAction(UIAction(handler: { [weak self] _ in
            self?.showSelectedDataViewController(.server)
        }), for: .touchUpInside)
        view.addSubview(selectServerButton)

        NSLayoutConstraint.activate([
            selectServerButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            selectServerButton.leadingAnchor.constraint(equalTo: view.safeArea.leadingAnchor, constant: 24),
            selectServerButton.trailingAnchor.constraint(equalTo: view.safeArea.trailingAnchor, constant: -24),
        ])
    }

    func setupSelectedUserButton() {
        selectUserButton.setActiveDesign()
        selectUserButton.setup()
        selectUserButton.setTitle("Пользователь", for: .normal)
        selectUserButton.translatesAutoresizingMaskIntoConstraints = false
        selectUserButton.addAction(UIAction(handler: { [weak self] _ in
            self?.showSelectedDataViewController(.user)
        }), for: .touchUpInside)

        view.addSubview(selectUserButton)
        NSLayoutConstraint.activate([
            selectUserButton.topAnchor.constraint(equalTo: selectServerButton.bottomAnchor, constant: 16),
            selectUserButton.leadingAnchor.constraint(equalTo: view.safeArea.leadingAnchor, constant: 24),
            selectUserButton.trailingAnchor.constraint(equalTo: view.safeArea.trailingAnchor, constant: -24),
        ])
    }

    func setupMainButton() {
        mainButton.setActiveDesign()
        mainButton.setup()
        mainButton.setTitle("Войти", for: .normal)
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        mainButton.addAction(UIAction(handler: { [weak self] _ in
            self?.openChat()
        }), for: .touchUpInside)

        view.addSubview(mainButton)
        NSLayoutConstraint.activate([
            mainButton.topAnchor.constraint(equalTo: selectUserButton.bottomAnchor, constant: 24),
            mainButton.leadingAnchor.constraint(equalTo: view.safeArea.leadingAnchor, constant: 24),
            mainButton.trailingAnchor.constraint(equalTo: view.safeArea.trailingAnchor, constant: -24),
        ])
    }

    func setupDemoButton() {
        demoButton.setActiveDesign()
        demoButton.setup()
        demoButton.setTitle("Демонстрационные примеры", for: .normal)
        demoButton.translatesAutoresizingMaskIntoConstraints = false
        demoButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else {
                return
            }

            let controller = DemoViewController()
            controller.lightTheme = makeLightTheme()
            controller.darkTheme = makeDarkTheme()
            navigationController?.pushViewController(controller, animated: true)
        }), for: .touchUpInside)
        view.addSubview(demoButton)

        NSLayoutConstraint.activate([
            demoButton.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: 16),
            demoButton.leadingAnchor.constraint(equalTo: view.safeArea.leadingAnchor, constant: 24),
            demoButton.trailingAnchor.constraint(equalTo: view.safeArea.trailingAnchor, constant: -24),
        ])
    }

    func setupInfoLabel() {
        let infoLabel: UILabel = .init()
        infoLabel.font = .systemFont(ofSize: 12)
        infoLabel.textAlignment = .center
        infoLabel.textColor = UIColor(named: "InfoLabelColor")

        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] ?? ""
        let sdkVersion = ChatCenterUISDK.version

        infoLabel.text = "Демо \(appVersion) (\(buildNumber)) / ChatCenterUI SDK \(sdkVersion)"
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoLabel)

        NSLayoutConstraint.activate([
            infoLabel.bottomAnchor.constraint(equalTo: view.safeArea.bottomAnchor, constant: -16),
            infoLabel.leadingAnchor.constraint(equalTo: view.safeArea.leadingAnchor, constant: 24),
            infoLabel.trailingAnchor.constraint(equalTo: view.safeArea.trailingAnchor, constant: -24),
        ])
    }

    func checkMainButtonAvailability() {
        let newSelectedServer = (Preferences().get(type: [Server].self, forKey: .servers) ?? []).first { $0.isSelected == true }
        if selectedServer?.name != newSelectedServer?.name {
            selectedServer = newSelectedServer
        }

        let newSelectedUser = (Preferences().get(type: [DemoUser].self, forKey: .users) ?? []).first { $0.isSelected == true }
        if selectedUser?.id != newSelectedUser?.id {
            selectedUser = newSelectedUser
        }

        mainButton.isEnabled = selectedUser != nil && selectedServer != nil
    }

    private func showSelectedDataViewController(_ type: SelectDataViewControllerType) {
        let viewController = SelectDataViewController(type)
        viewController.logoutHandler = { [weak self] user in
            self?.logout(user: user)
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
