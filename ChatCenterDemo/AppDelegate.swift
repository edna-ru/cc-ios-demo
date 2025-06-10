//
// AppDelegate.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import ChatCenterUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
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
        window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        window?.makeKeyAndVisible()

        return true
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// Передача токена  устройства для отправки пуш уведомлений из СДК
        ChatCenterUISDK.setDeviceToken(deviceToken)
    }
}
