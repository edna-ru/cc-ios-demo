//
// DemoViewController.swift
// ChatCenterDemo
//
// Copyright © 2026 edna. All rights reserved.
//

import ChatCenterUI
import SwiftUI
import UIKit

final class DemoViewController: UIViewController, UINavigationControllerDelegate {
    // MARK: Lifecycle

    deinit {
        demoServer.stop()
    }

    // MARK: Internal

    var theme: ChatTheme?
    var darkTheme: ChatTheme?

    let demoServer = ChatCenterServerEmulator()
    var chatCenterSdk: ChatCenterUISDK?

    var tableView = UITableView(frame: CGRect.zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Демонстрация"
        view.backgroundColor = .secondarySystemBackground
        demoServer.start()

        setupTableView()

        configureThreads()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .systemBackground
        tableView.keyboardDismissMode = .interactive
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SelectedTableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeArea.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeArea.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeArea.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

    func configureThreads() {
        let chatTransportConfig = ChatTransportConfig(rest: ChatCenterServerEmulator.URLS.rest,
                                                      webSocket: ChatCenterServerEmulator.URLS.websocket,
                                                      dataStore: ChatCenterServerEmulator.URLS.dataStore,
                                                      apiVersion: .api21)

        var chatConfig = ChatConfig(transportConfig: chatTransportConfig,
                                    networkConfig: ChatNetworkConfig(sslPinning: ChatNetworkConfig.SSLPinningConfig(allowUntrustedSSLCertificate: true)))
        chatConfig.shouldUseRemoteConfig = false
        chatConfig.searchEnabled = true
        chatConfig.voiceRecordingEnabled = false
//        chatConfig.linkPreviewEnabled = true
        chatConfig.showAttachButton = false

        chatCenterSdk = ChatCenterUISDK(providerUid: "edna_demo",
                                        chatConfig: chatConfig,
                                        loggerConfig: ChatLoggerConfig(logLevel: .all))

        if let theme {
            chatCenterSdk?.theme = theme
        }
        if let darkTheme {
            chatCenterSdk?.darkTheme = darkTheme
        }
        if let path = Bundle.main.path(forResource: appLanguage.rawValue, ofType: "lproj"), let bundle = Bundle(path: path) {
            chatCenterSdk?.localizationConfig = ChatLocalizationConfig(bundle: bundle, tableName: "DemoLocalizable")
        }

        navigationController?.delegate = self
    }

    func navigationController(_: UINavigationController, willShow viewController: UIViewController, animated _: Bool) {
        if demoServer.selectedUseCase != nil, viewController == self {
            try? chatCenterSdk?.logout()
        }
    }

    // MARK: Private

    @AppStorage(SettingsKeys.language.rawValue)
    private var appLanguage: AppLanguage = .russian
}

// MARK: UITableViewDataSource

extension DemoViewController: UITableViewDataSource {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        demoServer.selectedUseCase = ChatCenterServerEmulator.UseCases.allCases[indexPath.row]

        chatCenterSdk?.authorize(user: ChatUser(identifier: "id_\(indexPath.row)"))

        if let chatVC = try? chatCenterSdk?.getChat() {
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        44
    }

    func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        "ПРИМЕРЫ ДИАЛОГОВ"
    }
}

// MARK: UITableViewDelegate

extension DemoViewController: UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        ChatCenterServerEmulator.UseCases.allCases.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.font = .systemFont(ofSize: 17)
        cell?.textLabel?.textColor = UIColor(named: "MainColor") ?? .black
        cell?.textLabel?.text = ChatCenterServerEmulator.UseCases.allCases[indexPath.row].title
        return cell ?? SelectedTableViewCell()
    }
}
