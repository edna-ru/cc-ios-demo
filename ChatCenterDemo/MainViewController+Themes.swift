//
// MainViewController+Themes.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import ChatCenterUI
import UIKit

/// Настройки тем оформления
extension MainViewController {
    func makeLightTheme() -> ChatTheme {
        // Создание компонентов дизайн системы
        let components = ChatComponents(typography: typography)
        components.searchBarStyle.cancelButtonStyle.tintColor = .black

        // Создание темы
        let theme = ChatTheme(components: components)

        // Получение настроек экрана чата
        let chatFlow = theme.flows.chatFlow
        chatFlow.systemMessages.surveyMessageStyle.type = showSurveyInUserStyle ? .user : .system
        chatFlow.incomeMessages.showAvatar = showIncomeAvatar
        chatFlow.outcomeMessages.showAvatar = showOutcomeAvatar

        return theme
    }

    func makeDarkTheme() -> ChatTheme {
        // Создание компонентов дизайн системы
        let components = ChatComponents(images: darkImages,
                                        colors: colors,
                                        typography: typography)
        components.searchBarStyle.cancelButtonStyle.tintColor = .white

        // Создание темы из компонентов
        let theme = ChatTheme(components: components)

        // Получение настроек экрана чата
        let chatFlow = theme.flows.chatFlow
        chatFlow.systemMessages.surveyMessageStyle.type = showSurveyInUserStyle ? .user : .system
        chatFlow.incomeMessages.showAvatar = showIncomeAvatar
        chatFlow.outcomeMessages.showAvatar = showOutcomeAvatar
        let alignment = ChatInputAlignment(rawValue: inputAlignment) ?? .bottom
        chatFlow.inputViewStyle.inputText.alignment = alignment

        // Получение настроек экрана поиска
        let searchFlow = theme.flows.searchFlow
        searchFlow.searchMessageStyle.messageMatchStyle.color = .red

        return theme
    }

    private var colors: ChatColors {
        let colors = ChatColors()
        colors.main = UIColor(named: "MainColor") ?? .black
        colors.secondary = UIColor(named: "SecondaryColor") ?? .systemGreen
        colors.disabled = .systemGray3
        colors.background = .systemBackground
        colors.backgroundWhite = .systemFill
        colors.link = .systemBlue
        colors.linkLight = .systemBlue.withAlphaComponent(0.7)
        colors.positive = UIColor(named: "SecondaryColor") ?? .systemTeal
        colors.warning = .systemOrange
        colors.error = .systemRed
        colors.errorLight = .systemRed.withAlphaComponent(0.7)
        return colors
    }

    private var typography: ChatTypography {
        let fonts = ChatTypography()
        fonts.title = .systemFont(ofSize: 12, weight: .medium)
        fonts.bold = .systemFont(ofSize: 15, weight: .regular)
        fonts.message = .systemFont(ofSize: 15, weight: .regular)
        return fonts
    }

    private var darkImages: ChatImages {
        let images = ChatImages()
        images.avatarPlaceholderImage = ChatImage(system: "person.circle.fill", tintColor: UIColor.white)
        images.errorInfoImage = ChatImage(system: "repeat.circle", tintColor: .white)
        return images
    }
}
