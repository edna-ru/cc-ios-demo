//
// AppDelegate.swift
// ChatCenterDemo
//
// Copyright © 2026 edna. All rights reserved.
//

import ChatCenterUI
import SwiftUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Internal

    var window: UIWindow?

    /**

     Рекомендуемое место инициализации СДК

     В демо приложении мы используем переключение серверов (для удобства тестирования),
     поэтому инициализация находится в MainViewController, где СДК инициализируется с выбранным сервером.

     В обычном приложении с одним сервером это не нужно

     */
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //		// 1. Настройка подключения к серверу
        //		let chatTransportConfig = ChatTransportConfig(cloudHost: "*host*.edna.ru")

        //		// 2. Настройка параметров работы чата
        //		var chatConfig = ChatConfig(transportConfig: chatTransportConfig)

        //		// 3. Инициализация СДК
        //		let chatCenterSdk = ChatCenterUISDK(providerUid: "providerUid",
        //											chatConfig: chatConfig,
        //											loggerConfig: ChatLoggerConfig(logLevel: .all))

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .secondarySystemBackground
        window?.rootViewController = UINavigationController(rootViewController: mainController)
        window?.makeKeyAndVisible()

        if showFpsRam {
            DebugOverlay.shared.show()
        }

        return true
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("Failed to register: \(error)")
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Передача токена  устройства для отправки пуш уведомлений из СДК
        ChatCenterUISDK.setDeviceToken(deviceToken)
    }

    func application(_: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler _: @escaping (UIBackgroundFetchResult) -> Void) {
        mainController.openChat(with: userInfo)
    }

    // MARK: Private

    @AppStorage(SettingsKeys.showFpsRam.rawValue)
    private var showFpsRam: Bool = false

    private let mainController = MainViewController()
}
