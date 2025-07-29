//
// SettingsView.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import SwiftUI

struct BooleanSetting: Identifiable {
    let title: String
    let key: String

    var id: String { key }
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
    case keepWebSocketActive
    case showIncomeAvatar
    case showOutcomeAvatar
    case inputAlignment
    case userStyleSurvey
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

        var id: Self { self }
    }

    let settings: [BooleanSetting] = [
        BooleanSetting(title: "Поиск", key: SettingsKeys.searchEnabled.rawValue),
        BooleanSetting(title: "Голосовые сообщения", key: SettingsKeys.voiceRecordingEnabled.rawValue),
        BooleanSetting(title: "Отображение OpenGraph", key: SettingsKeys.linkPreviewEnabled.rawValue),
        BooleanSetting(title: "Оставлять WebSocket активным (тест счетчика)", key: SettingsKeys.keepWebSocketActive.rawValue),
    ]
    let uiSettings: [BooleanSetting] = [
        BooleanSetting(title: "Завершение опроса в старом стиле", key: SettingsKeys.userStyleSurvey.rawValue),
        BooleanSetting(title: "Отображение аватара оператора", key: SettingsKeys.showIncomeAvatar.rawValue),
        BooleanSetting(title: "Отображение аватара клиента", key: SettingsKeys.showOutcomeAvatar.rawValue),
    ]

    var body: some View {
        Form {
            Section {
                ForEach(settings) { setting in
                    ToggleRow(setting)
                }
            } header: {
                Text("Настройки SDK").font(.headline)
            }
            Section {
                ForEach(uiSettings) { setting in
                    ToggleRow(setting)
                }
                Picker("Выравнивание кнопок ввода:", selection: $selectedAlignment) {
                    ForEach(AlignmentMode.allCases) { mode in
                        Text(mode.title)
                    }
                }.onChange(of: selectedAlignment) { tag in
                    UserDefaults.standard.set(tag.rawValue, forKey: SettingsKeys.inputAlignment.rawValue)
                }
            } header: {
                Text("Настройки UI").font(.headline)
            }
        }
        Text("*для применения изменений перезапустите приложение")
            .font(.caption).italic()
    }

    // MARK: Private

    @State
    private var selectedAlignment: AlignmentMode = .init(rawValue: UserDefaults.standard.integer(forKey: SettingsKeys.inputAlignment.rawValue)) ?? .bottom
}

#Preview {
    SettingsView()
}
