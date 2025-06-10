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
}

struct SettingsView: View {
    let settings: [BooleanSetting] = [
        BooleanSetting(title: "Поиск", key: SettingsKeys.searchEnabled.rawValue),
        BooleanSetting(title: "Голосовые сообщения", key: SettingsKeys.voiceRecordingEnabled.rawValue),
        BooleanSetting(title: "Отображение OpenGraph", key: SettingsKeys.linkPreviewEnabled.rawValue),
        BooleanSetting(title: "Оставлять WebSocket активным (тест счетчика)", key: SettingsKeys.keepWebSocketActive.rawValue),
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
        }
        Text("*для применения изменений перезапустите приложение")
            .font(.caption).italic()
    }
}

#Preview {
    SettingsView()
}
