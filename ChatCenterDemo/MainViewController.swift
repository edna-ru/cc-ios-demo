//
// MainViewController.swift
// ChatCenterDemo
//
// Copyright © 2026 edna. All rights reserved.
//

import ChatCenterUI
import SwiftUI
import UIKit
import SafariServices

/// Главный экран демо приложения
final class MainViewController: UIViewController {
    // MARK: Internal

    @AppStorage(SettingsKeys.userStyleSurvey.rawValue)
    var showSurveyInUserStyle: Bool = false

    @AppStorage(SettingsKeys.showIncomeAvatar.rawValue)
    var showIncomeAvatar: Bool = false

    @AppStorage(SettingsKeys.keyboardControlVisible.rawValue)
    var keyboardControlVisible: Bool = false

    @AppStorage(SettingsKeys.showOutcomeAvatar.rawValue)
    var showOutcomeAvatar: Bool = false

    @AppStorage(SettingsKeys.inputAlignment.rawValue)
    var inputAlignment: Int = 0

    @AppStorage(SettingsKeys.sdkTheme.rawValue)
    var sdkTheme: SDKTheme = .system

    let imageView = UIImageView()
    let titleLabel = UILabel()
    let selectServerButton = SelectedButton()
    let selectUserButton = SelectedButton()
    let mainButton = MainButton()
    let demoButton = DemoButton()
    var chatUser: ChatUser?

    /// Экземпляр СДК
    var chatCenterSDK: ChatCenterUISDK?

    var selectedServer: Server? {
        didSet {
            guard let selectedServer else {
                selectServerButton.setTitle("Выберите сервер", for: .normal)
                selectServerButton.isValue = false
                return
            }

            selectServerButton.setTitle(selectedServer.name, for: .normal)
            selectServerButton.isValue = true

            // Вызываем тут, т.к меняется сервер и нужно переинициализировать СДК с новыми данными
            setupSDK()

            // Если меняется сервер при уже выбранном пользователе
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

        DispatchQueue.global().async {
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            ) { success, error in
                guard success else {
                    print(error?.localizedDescription ?? "")
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
                                                      dataStore: selectedServer.dataStoreURL,
                                                      apiVersion: ChatTransportConfig.APIVersion(rawValue: selectedServer.apiVersion) ?? .api17)

        // 2. Настройка параметров сетевого подключения
        var chatNetworkConfig = ChatNetworkConfig()
        chatNetworkConfig.httpConfig.uploadTimeout = 10
        chatNetworkConfig.sslPinning.allowUntrustedSSLCertificate = true

        // 3. Настройка параметров работы чата
        var chatConfig = ChatConfig(transportConfig: chatTransportConfig,
                                    networkConfig: chatNetworkConfig)
        chatConfig.shouldUseRemoteConfig = shouldUseRemoteConfig
        chatConfig.searchEnabled = searchEnabled
        chatConfig.voiceRecordingEnabled = voiceRecordingEnabled
        chatConfig.linkPreviewEnabled = linkPreviewEnabled
        chatConfig.keepSocketActive = keepWebSocketActive
        chatConfig.keepSocketActiveDuringOperatorSession = keepSocketActiveDuringOperatorSession

        // 4. Инициализация СДК
        let chatCenterSdk = ChatCenterUISDK(providerUid: selectedServer.providerUid,
                                            appMarker: selectedServer.appMarker,
                                            chatConfig: chatConfig,
                                            loggerConfig: ChatLoggerConfig(logLevel: .all))

        // 5. Настройка тем оформления
        if sdkTheme == .system {
            // берутся дефолтные настройки
        } else if sdkTheme == .full {
            chatCenterSdk.theme = makeFullTheme()
        } else {
            chatCenterSdk.theme = makeTheme()
        }

        // 6. Подписка на события делегата (если нужно, в этом примере для обработки счетчика непрочитанных)
        chatCenterSdk.delegate = self

        // Предзаполненное сообщение (если используется)
        if let prefilledMessage {
            chatCenterSdk.prefill(message: prefilledMessage)
        }

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
                                data: sendUserDataBeforeOpenChat ? nil : selectedUser.data)

        // Установка пользователя в СДК
        self.chatUser = chatUser
        chatCenterSDK.authorize(user: chatUser)
    }

    /// Открытие чата
    func openChat(with userInfo: [AnyHashable: Any]? = nil) {
        guard let chatCenterSDK else {
            return
        }

        // Проверяем что переход по пушу и экран чата уже открыт
        if let userInfo, navigationController?.topViewController == chatController {
            // Пытаемся обработать пуш в чате
            try? chatCenterSDK.handleNotification(userInfo: userInfo)
            return
        }

        // Повторно устанавливаем тему, т.к в демке можно менять динамически
        if sdkTheme == .system {
            chatCenterSDK.theme = ChatTheme(components: ChatComponents())
        } else if sdkTheme == .full {
            chatCenterSDK.theme = makeFullTheme()
        } else {
            chatCenterSDK.theme = makeTheme()
        }

        if let path = Bundle.main.path(forResource: appLanguage.rawValue, ofType: "lproj"), let bundle = Bundle(path: path) {
            let locale = Locale(identifier: appLanguage.id)
            chatCenterSDK.localizationConfig = ChatLocalizationConfig(bundle: bundle, tableName: "DemoLocalizable", locale: locale)
        }

        // Получение контроллера чата
        let result = Result { try chatCenterSDK.getChat(userInfo: userInfo) }

        switch result {
        case let .success(chatController):
            self.chatController = chatController

            if sendUserDataBeforeOpenChat {
                chatUser?.updateData(data: selectedUser?.data)
            }
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

    @AppStorage(SettingsKeys.language.rawValue)
    private var appLanguage: AppLanguage = .russian

    @AppStorage(SettingsKeys.shouldUseRemoteConfig.rawValue)
    private var shouldUseRemoteConfig: Bool = false

    @AppStorage(SettingsKeys.searchEnabled.rawValue)
    private var searchEnabled: Bool = false

    @AppStorage(SettingsKeys.voiceRecordingEnabled.rawValue)
    private var voiceRecordingEnabled: Bool = false

    @AppStorage(SettingsKeys.linkPreviewEnabled.rawValue)
    private var linkPreviewEnabled: Bool = false

    @AppStorage(SettingsKeys.keepWebSocketActive.rawValue)
    private var keepWebSocketActive: Bool = false

    @AppStorage(SettingsKeys.keepSocketActiveDuringOperatorSession.rawValue)
    private var keepSocketActiveDuringOperatorSession: Bool = false

    @AppStorage(SettingsKeys.prefilledMessage.rawValue)
    private var prefilledMessage: String?

    @AppStorage(SettingsKeys.openURLAppEnabled.rawValue)
    private var openURLAppEnabled: Bool = false

    @AppStorage(SettingsKeys.sendUserDataBeforeOpenChat.rawValue)
    private var sendUserDataBeforeOpenChat: Bool = false

    /// Текущий контроллер чата
    private weak var chatController: UIViewController?
}

/// Реализация делегата ChatCenterUI SDK
extension MainViewController: @preconcurrency ChatCenterUISDKDelegate {

    /// Реализация метода oбработки открытия ссылки
    func chatCenterUI(chatCenter _: ChatCenterUISDK, didOpen url: URL) -> Bool {
        if openURLAppEnabled {
            let controller = SFSafariViewController(url: url)
            controller.modalPresentationStyle = .formSheet
            navigationController?.present(controller, animated: true)

        }

        return openURLAppEnabled
    }

    /// Реализация метода оповещения о новых сообщениях
    func chatCenterUI(chatCenter _: ChatCenterUI.ChatCenterUISDK, didChangeUnreadMessages count: Int) {
        mainButton.setBadgeCount(count)
    }

    func chatCenterUI(chatCenter _: ChatCenterUISDK, didReceiveNetwork error: any Error) {
        // показываем в демо ошибки запросов до открытия чата
        if navigationController?.topViewController == self {
            let alert = UIAlertController(title: "Сетевая ошибка в СДК", message: error.localizedDescription, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
}
