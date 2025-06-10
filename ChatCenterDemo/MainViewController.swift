//
// MainViewController.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import ChatCenterUI
import SwiftUI
import UIKit

/// Главный экран демо приложения
final class MainViewController: UIViewController {
    // MARK: Internal

    @AppStorage(SettingsKeys.showIncomeAvatar.rawValue)
    var showIncomeAvatar: Bool = false

    @AppStorage(SettingsKeys.showOutcomeAvatar.rawValue)
    var showOutcomeAvatar: Bool = false

    let imageView = UIImageView()
    let titleLabel = UILabel()
    let selectServerButton = SelectedButton()
    let selectUserButton = SelectedButton()
    let mainButton = MainButton()
    let demoButton = DemoButton()

    var selectedServer: Server? {
        didSet {
            guard let selectedServer else {
                selectServerButton.setTitle("Выберите сервер", for: .normal)
                selectServerButton.isValue = false
                return
            }

            selectServerButton.setTitle(selectedServer.name, for: .normal)
            selectServerButton.isValue = true

            /// Вызываем тут, т.к меняется сервер и нужно переинициализировать СДК с новыми данными
            setupSDK()

            /// Если меняется сервер при уже выбраннмо пользователе
            if let selectedUser {
                authUser(user: selectedUser)
            }
        }
    }

    var selectedUser: DemoUser? {
        didSet {
            guard let selectedUser else {
                selectUserButton.setTitle("Выберите пользователя", for: .normal)
                selectUserButton.isValue = false
                return
            }
            selectUserButton.setTitle(selectedUser.id, for: .normal)
            selectUserButton.isValue = true

            authUser(user: selectedUser)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else {
                return
            }

            UNUserNotificationCenter.current().getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else {
                    return
                }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }

        // Рекомендуемое место вызова, если нет смены сервера
//        setupSDK()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkMainButtonAvailability()
    }

    /// Инициализация и настройка СДК
    func setupSDK() {
        guard let selectedServer else {
            alert(title: "Ошибка", message: "Не найдены настройки подключения к серверу")
            return
        }

        // 1. Настройка подключения к серверу
        let chatTransportConfig = ChatTransportConfig(rest: selectedServer.restURL,
                                                      webSocket: selectedServer.webSocketURL,
                                                      dataStore: selectedServer.dataStoreURL)
        // 2. Настройка параметров сетевого подключения
        var chatNetworkConfig = ChatNetworkConfig()
        chatNetworkConfig.sslPinning.allowUntrustedSSLCertificate = true

        // 3. Настройка параметров работы чата
        var chatConfig = ChatConfig(transportConfig: chatTransportConfig,
                                    networkConfig: chatNetworkConfig)
        chatConfig.searchEnabled = searchEnabled
        chatConfig.voiceRecordingEnabled = voiceRecordingEnabled
        chatConfig.linkPreviewEnabled = linkPreviewEnabled
        chatConfig.keepSocketActive = keepWebSocketActive

        // 4. Инициализация СДК
        let chatCenterSdk = ChatCenterUISDK(providerUid: selectedServer.providerUid,
                                            appMarker: selectedServer.appMarker,
                                            chatConfig: chatConfig,
                                            loggerConfig: ChatLoggerConfig(logLevel: .all))

        // 5. Настройка тем оформления
        chatCenterSdk.theme = makeLightTheme()
        chatCenterSdk.darkTheme = makeDarkTheme()

        // 6. Подписка на события делегата (если нужно, в этом примере для обработки счетчика непрочитанных)
        chatCenterSdk.delegate = self

        // 7. Сохранение экземпляра для дальнейшего использования
        chatCenterSDK = chatCenterSdk
    }

    /// Установка пользователя в СДК (обязательный шаг перед открытием чата)
    func authUser(user _: DemoUser) {
        guard let chatCenterSDK, let selectedUser else {
            alert(title: "Ошибка", message: "Пользователь не задан")
            return
        }

        // Создание модели пользователя
        let chatUser = ChatUser(identifier: selectedUser.id,
                                name: selectedUser.name,
                                data: selectedUser.data)

        // Установка пользователя в СДК
        chatCenterSDK.authorize(user: chatUser)
    }

    /// Открытие чата
    func openChat() {
        guard let chatCenterSDK else {
            return
        }

        // Получение контроллера чата
        let result = Result { try chatCenterSDK.getChat() }

        switch result {
        case let .success(chatController):
            // Открытие экрана чата
            navigationController?.pushViewController(chatController, animated: true)
        case let .failure(error):
            // Обработка ошибки (нет пользователя)
            print("error: \(error)")
        }
    }

    /// Удаление пользователя (вызывается при смене пользователя)
    func logout(user: DemoUser) {
        if let selectedUser, selectedUser.id == user.id {
            let result = Result { try chatCenterSDK?.logout() }

            switch result {
            case .success:
                self.selectedUser = nil
            case let .failure(error):
                // Обработка ошибки
                print("error: \(error)")
            }
        }
    }

    // MARK: Private

    @AppStorage(SettingsKeys.searchEnabled.rawValue)
    private var searchEnabled: Bool = false

    @AppStorage(SettingsKeys.voiceRecordingEnabled.rawValue)
    private var voiceRecordingEnabled: Bool = false

    @AppStorage(SettingsKeys.linkPreviewEnabled.rawValue)
    private var linkPreviewEnabled: Bool = false

    @AppStorage(SettingsKeys.keepWebSocketActive.rawValue)
    private var keepWebSocketActive: Bool = false

    /// Экземпляр СДК
    private var chatCenterSDK: ChatCenterUISDK?
}

/// Реализация делегата ChatCenterUI SDK
extension MainViewController: ChatCenterUISDKDelegate {
    /// Реализация метода оповещения о новых сообщениях
    func chatCenterUI(chatCenter _: ChatCenterUI.ChatCenterUISDK, didChangeUnreadMessages count: Int) {
        mainButton.setBadgeCount(count)
    }
}
