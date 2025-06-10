//
// ChatCenterServerEmulator.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import Foundation
import Swifter

/// Демо сервер для тестирования и демонстрации функционала
class ChatCenterServerEmulator {
    // MARK: Lifecycle

    init() {
        server["/websocket"] = websocket(text: { session, text in
            guard let model = text.parse(to: Action.self) else {
                return
            }
            if model.action == Actions.registerDevice.rawValue {
                session.writeText(ConstantsResponse.testResponse.getResponse(correlationId: model.correlationId))
            }
            if model.action == Actions.sendMessage.rawValue {
                switch model.data?.content?.type {
                case "INIT_CHAT":
                    session.writeText(ConstantsResponse.initChat.getResponse(correlationId: model.correlationId))
                case "CLIENT_INFO":
                    session.writeText(ConstantsResponse.initChat.getResponse(correlationId: model.correlationId))
                default:
                    break
                }
            }
        })

        server["/api/chat/config"] = { [weak self] _ in
            guard self != nil else {
                return HttpResponse.notFound
            }

            if self?.selectedUseCase == .errorConfig {
                return .internalServerError
            }

            if let url = Bundle.main.url(forResource: "config_response", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let response = HttpResponse.ok(.data(data, contentType: "application/json"))
                    return response
                } catch {
                    print("error:\(error)")
                }
            }
            return HttpResponse.notFound
        }

        server["/api/client/history"] = { [weak self] _ in
            guard let self, let selectedCase = selectedUseCase else {
                return HttpResponse.notFound
            }

            if selectedCase == .errorHistory {
                return .internalServerError
            }

            if let url = Bundle.main.url(
                forResource: selectedCase.historyPath,
                withExtension: "json"
            ) {
                do {
                    let data = try Data(contentsOf: url)
                    let response = HttpResponse.ok(.data(data, contentType: "application/json"))
                    return response
                } catch {
                    print("error:\(error)")
                }
            }
            return HttpResponse.notFound
        }

        server["/files/:number"] = { request in
            guard let fileName = request.params[":number"] else {
                return HttpResponse.notFound
            }
            let result = fileName.split(separator: ".")
            let name = String(result[0])
            let extensionName = String(result[1])

            if let url = Bundle.main.url(forResource: name, withExtension: extensionName) {
                do {
                    let data = try Data(contentsOf: url)
                    return HttpResponse.ok(.data(data, contentType: "Content-Type"))
                } catch {
                    print("error:\(error)")
                }
            }
            return HttpResponse.notFound
        }
    }

    // MARK: Internal

    /// Ссылки для подключения
    enum URLS {
        static let websocket = "ws://localhost:9089/websocket"
        static let rest = "http://localhost:9089"
        static let dataStore = "http://localhost:9089/files"
    }

    /// Сообщения вебсокета
    enum Actions: String {
        case registerDevice
        case sendMessage
    }

    /// Демо сценарии
    enum UseCases: CaseIterable {
        case files
        case images
        case system
        case text
        case voice
        case bot
        case errors
        case errorHistory
        case errorConfig
        case expiredFiles
        case emptyFile

        // MARK: Internal

        /// Заголовок для выбора
        var title: String {
            switch self {
            case .files:
                "Файлы"
            case .images:
                "Картинки"
            case .system:
                "Системные сообщения"
            case .text:
                "Текстовые сообщения"
            case .voice:
                "Голосовые сообщения"
            case .bot:
                "Бот"
            case .errors:
                "Ошибки подключения"
            case .errorHistory:
                "Ошибка загрузки истории"
            case .errorConfig:
                "Ошибка загрузки конфигурации"
            case .expiredFiles:
                "Статусы expired"
            case .emptyFile:
                "Пустая история"
            }
        }

        /// Мок истории для сценария
        var historyPath: String {
            switch self {
            case .files:
                "history_files_response"
            case .images:
                "history_images_response"
            case .system:
                "history_system_response"
            case .text:
                "history_text_response"
            case .voice:
                "history_voice_response"
            case .bot:
                "history_bot_response"
            case .errors:
                "history_errors_response"
            case .errorHistory:
                "error"
            case .errorConfig:
                "history_text_response"
            case .expiredFiles:
                "history_expired_response"
            case .emptyFile:
                "history_empty_response"
            }
        }
    }

    /// Текущий теструемый сценарий
    var selectedUseCase: UseCases?

    /// Запуск сервера
    func start() {
        do {
            try server.start(9089)
            try print("Server has started ( port = \(server.port()) ). Try to connect now...")
        } catch {
            print("Server start error: \(error)")
        }
    }

    /// Остановка сервера
    func stop() {
        server.stop()
    }

    // MARK: Private

    private let server = HttpServer()
}
