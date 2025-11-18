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
        let components = ChatComponents.build { components in
            components.searchBarStyle.cancelButtonStyle.tintColor = .black
            components.loadingChatStyle.indicatorStyle.backgroundColor = .systemGray3
            components.loadingChatStyle.indicatorStyle.cornerRadius = 20.0
            components.audioPlayerStyle.playButtonStyle.image = ChatImage(system: "play.fill", tintColor: .black)
            components.audioPlayerStyle.pauseButtonStyle.image = ChatImage(system: "pause.fill", tintColor: .gray)
            components.audioPlayerStyle.progressViewStyle.color = .black
            components.audioPlayerStyle.progressViewStyle.backgroundColor = .white
        }

        // Создание темы
        let theme = ChatTheme(components: components)

        let authorText = ChatTextStyle(font: UIFont.systemFont(ofSize: 10), color: .black)
        let quoteText = ChatTextStyle(font: UIFont.systemFont(ofSize: 10), color: .darkGray)

        // Применение настроек для экрана чата
        theme.flows.chatFlow.apply { chatFlow in
            chatFlow.pullToRefreshColor = .systemBlue
            // настройки входящих сообщений через создание нового стиля
            chatFlow.incomeMessages = .build(with: components, configure: { style in
                style.quoteStyle = .build(with: components, configure: { quote in
                    quote.authorTextStyle = authorText
                    quote.messageTextStyle = quoteText
                    quote.separatorColor = .green
                    quote.showFullName = true
                    quote.backgroundColor = .lightText
                })
                style.textMessageStyle.openGraphStyle.urlTextStyle.color = .gray
                style.showAvatar = showIncomeAvatar
                style.textMessageStyle.textStyle.color = .black
                style.bubbleTintColor = .lightText
            })
            // настройки существующего стиля для исходящих сообщений
            chatFlow.outcomeMessages.apply { style in
                style.textMessageStyle.textStyle.color = .black
                style.showAvatar = showOutcomeAvatar
                style.textMessageStyle.openGraphStyle.urlTextStyle.color = .link
                style.bubbleErrorColor = .red
                style.imageMessageStyle.timeBackgroundColor = .white
            }
        }

        // Применение настроек для экрана поиска
        theme.flows.searchFlow.apply {
            $0.navigationBarStyle = NavigationBarStyle.build(with: components, configure: {
                $0.hidden = false
                $0.backButtonColor = .red
            })
            $0.searchMessageStyle.apply {
                $0.matchTextStyle = .init(font: UIFont.systemFont(ofSize: 20), color: .systemGreen)
                $0.nextImage = ChatImage(system: "chevron.forward", tintColor: .systemGreen)
            }
            $0.navigationBarStyle.searchBarStyle.cancelButtonStyle.tintColor = .red
            $0.notFoundTextStyle = ChatTextStyle(font: typography.message, color: .red)
        }

        return theme
    }

    func makeDarkTheme() -> ChatTheme {
        // Создание компонентов дизайн системы
        let components = ChatComponents(images: chatImages,
                                        colors: colors,
                                        typography: typography)
        components.searchBarStyle.cancelButtonStyle.tintColor = .white

        // Создание темы из компонентов
        let theme = ChatTheme(components: components)

        // Получение настроек экрана чата
        let chatFlow = theme.flows.chatFlow
        chatFlow.incomeMessages.showAvatar = showIncomeAvatar
        chatFlow.outcomeMessages.showAvatar = showOutcomeAvatar
        let alignment = ChatInputAlignment(rawValue: inputAlignment) ?? .bottom
        chatFlow.inputViewStyle.inputTextStyle.alignment = alignment

        // Получение настроек экрана поиска
        let searchFlow = theme.flows.searchFlow
        searchFlow.navigationBarStyle.hidden = false
        searchFlow.navigationBarStyle.searchBarStyle.cancelButtonStyle.tintColor = .white
        searchFlow.searchMessageStyle.matchTextStyle.color = .red
        searchFlow.notFoundTextStyle = ChatTextStyle(font: typography.message, color: .white)

        return theme
    }

    private var colors: ChatColors {
        let colors = ChatColors()
        colors.main = UIColor(named: "MainColor") ?? .black
        colors.secondary = UIColor(named: "SecondColor") ?? .systemGreen
        colors.disabled = .systemGray3
        colors.background = .systemBackground
        colors.backgroundWhite = .systemFill
        colors.link = .systemBlue
        colors.linkLight = .systemBlue.withAlphaComponent(0.7)
        colors.positive = UIColor(named: "SecondColor") ?? .systemTeal
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

    private var chatImages: ChatImages {
        let images = ChatImages()
        images.avatarPlaceholderImage = ChatImage(system: "person.circle.fill", tintColor: .systemGreen)
        images.errorInfoImage = ChatImage(system: "repeat.circle", tintColor: .systemRed)
        images.emptyChatPlaceholderImage = ChatImage(named: "welcome_image", bundle: Bundle.main)
        return images
    }
}
