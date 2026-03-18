//
// SettingsView.swift
// ChatCenterDemo
//
// Copyright © 2026 edna. All rights reserved.
//

import SwiftUI

struct BooleanSetting: Identifiable {
    let title: String
    let key: String

    var id: String {
        key
    }
}

struct ToggleRow: View {
    // MARK: Lifecycle

    init(_ booleanSetting: BooleanSetting) {
        title = booleanSetting.title
        setting = AppStorage(wrappedValue: false, booleanSetting.key)
    }

    // MARK: Internal

    let title: String

    var body: some View {
        Toggle(title, isOn: setting.projectedValue)
    }

    // MARK: Private

    private var setting: AppStorage<Bool>

    private var settingValue: Bool {
        setting.wrappedValue
    }
}

enum SettingsKeys: String {
    case searchEnabled
    case voiceRecordingEnabled
    case linkPreviewEnabled
    case shouldUseRemoteConfig
    case keepWebSocketActive
    case keepSocketActiveDuringOperatorSession
    case showIncomeAvatar
    case showOutcomeAvatar
    case keyboardControlVisible
    case inputAlignment
    case userStyleSurvey
    case language
    case sdkTheme
    case showFpsRam
    case prefilledMessage
    case openURLAppEnabled
    case sendUserDataBeforeOpenChat
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case russian = "ru"
    case english = "en"
    case kazakh = "kk-KZ"

    // MARK: Internal

    var title: String {
        switch self {
        case .russian:
            "Русский"
        case .english:
            "English"
        case .kazakh:
            "Қазақша"
        }
    }

    var id: String {
        rawValue
    }
}

enum SDKTheme: String, CaseIterable, Identifiable {
    case system
    case full
    case second

    // MARK: Internal

    var title: String {
        switch self {
        case .system: "Системная"
        case .full: "Полная"
        case .second: "Клиентская"
        }
    }

    var id: String {
        rawValue
    }
}

struct SettingsView: View {
    // MARK: Internal

    enum AlignmentMode: Int, CaseIterable, Identifiable {
        case top = 2
        case center = 1
        case bottom = 0

        // MARK: Internal

        var title: String {
            switch self {
            case .top:
                "Top"
            case .center:
                "Center"
            case .bottom:
                "Bottom"
            }
        }

        var id: Self {
            self
        }
    }

    let settings: [BooleanSetting] = [
        BooleanSetting(title: "Настройки из серверного конфига", key: SettingsKeys.shouldUseRemoteConfig.rawValue),
        BooleanSetting(title: "Поиск", key: SettingsKeys.searchEnabled.rawValue),
        BooleanSetting(title: "Голосовые сообщения", key: SettingsKeys.voiceRecordingEnabled.rawValue),
        BooleanSetting(title: "Отображение OpenGraph", key: SettingsKeys.linkPreviewEnabled.rawValue),
        BooleanSetting(title: "Оставлять WebSocket активным (тест счетчика)", key: SettingsKeys.keepWebSocketActive.rawValue),
        BooleanSetting(title: "Оставлять WebSocket активным пока есть диалог", key: SettingsKeys.keepSocketActiveDuringOperatorSession.rawValue),
        BooleanSetting(title: "Открывать ссылки в приложении", key: SettingsKeys.openURLAppEnabled.rawValue),
        BooleanSetting(title: "Доотправить данные пользователя, перед открытием чата", key: SettingsKeys.sendUserDataBeforeOpenChat.rawValue)
    ]

    let uiSettings: [BooleanSetting] = [
        BooleanSetting(title: "Завершение опроса в старом стиле", key: SettingsKeys.userStyleSurvey.rawValue),
        BooleanSetting(title: "Отображение аватара оператора", key: SettingsKeys.showIncomeAvatar.rawValue),
        BooleanSetting(title: "Отображение аватара клиента", key: SettingsKeys.showOutcomeAvatar.rawValue),
        BooleanSetting(title: "Отображение кнопки скрытия/открытия клавиатуры", key: SettingsKeys.keyboardControlVisible.rawValue)
    ]

    /// Новая секция "Настройки Демо"
    let demoSettings: [BooleanSetting] = [
        BooleanSetting(title: "Отображение FPS/RAM", key: SettingsKeys.showFpsRam.rawValue)
    ]

    var body: some View {
        Form {
            Section {
                ForEach(settings) { setting in
                    ToggleRow(setting)
                }
                HStack(alignment: .firstTextBaseline) {
                    Text("Сообщение:")
                    TextField("Введите сообщение", text: $prefilledMessage)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.leading)
                }
                .onChange(of: prefilledMessage) { newValue in
                    UserDefaults.standard.set(newValue, forKey: SettingsKeys.prefilledMessage.rawValue)
                }
            } header: {
                Text("Настройки SDK﹡").font(.headline)
            }
            Section {
                ForEach(uiSettings) { setting in
                    ToggleRow(setting)
                }
                Picker("Выравнивание кнопок ввода:", selection: $selectedAlignment) {
                    ForEach(AlignmentMode.allCases) { mode in
                        Text(mode.title)
                    }
                }
                .onChange(of: selectedAlignment) { tag in
                    UserDefaults.standard.set(tag.rawValue, forKey: SettingsKeys.inputAlignment.rawValue)
                }
            } header: {
                Text("Настройки UI﹡").font(.headline)
            }
            Section {
                Picker("Выбор языка:", selection: $selectedLanguage) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text(lang.title).tag(lang)
                    }
                }
                .onChange(of: selectedLanguage) { lang in
                    UserDefaults.standard.set(lang.rawValue, forKey: SettingsKeys.language.rawValue)
                }
            } header: {
                Text("Настройки языка").font(.headline)
            }

            Section {
                Picker("Тема оформления:", selection: $selectedTheme) {
                    ForEach(SDKTheme.allCases) { theme in
                        Text(theme.title).tag(theme)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedTheme) { theme in
                    UserDefaults.standard.set(theme.rawValue, forKey: SettingsKeys.sdkTheme.rawValue)
                }
            } header: {
                HStack {
                    Image(systemName: "paintpalette")
                        .foregroundColor(.accentColor)
                    Text("Тема оформления SDK").font(.headline)
                }
            }
            .listRowBackground(Color(.secondarySystemBackground))

            Section {
                ForEach(demoSettings) { setting in
                    ToggleRow(setting)
                }
            } header: {
                Text("Настройки приложения﹡").font(.headline)
            }
        }
        Text("﹡для применения изменений перезапустите приложение")
            .font(.caption)
    }

    // MARK: Private

    @State
    private var selectedAlignment: AlignmentMode = .init(rawValue: UserDefaults.standard.integer(forKey: SettingsKeys.inputAlignment.rawValue)) ?? .bottom

    @State
    private var selectedLanguage: AppLanguage = {
        let code = UserDefaults.standard.string(forKey: SettingsKeys.language.rawValue) ?? AppLanguage.russian.rawValue
        return AppLanguage(rawValue: code) ?? .russian
    }()

    @State
    private var selectedTheme: SDKTheme = {
        let raw = UserDefaults.standard.string(forKey: SettingsKeys.sdkTheme.rawValue) ?? SDKTheme.system.rawValue
        return SDKTheme(rawValue: raw) ?? .system
    }()

    @State
    private var prefilledMessage: String = UserDefaults.standard.string(forKey: SettingsKeys.prefilledMessage.rawValue) ?? ""
}

#Preview {
    SettingsView()
}
