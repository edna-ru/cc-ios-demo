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
    /*

     В СДК 3 уровня кастомизации интерфейса:

     1. Минимальный. Настройка цветов, шрифтов и/или изображений (например, под корпоративные цвета)

     2. Покомпонентный. Настройка компонентов дизайн системы СДК (переиспользуемые элементы, например кнопка)

     3. Точечный. Детальная настройка flow (экраны чата или поиска), в этом случае настраивается внешний вид конкретного элемента на экране

     Уровни имеют вложенную структуру:

     let components = ChatComponents(images: ChatImages(), colors: ChatColors(), typography: ChatTypography())
     let flows = ChatFlows(components: components)
     let theme = ChatTheme(flows: flows)

     Приоритет у нижних выше, т.е если в ChatFlow установить цвет элемента, он заменит цвет заданнный в компоненте ChatColors
     */

    func makeLightTheme() -> ChatTheme {
        // переопределяем шрифты в теме
        let flow = ChatFlow(components: ChatComponents(typography: typography))
        // меняем отображение аватаров
        flow.incomeMessages.showAvatar = showIncomeAvatar
        flow.outcomeMessages.showAvatar = showOutcomeAvatar
        return ChatTheme(flows: ChatFlows(chatFlow: flow))
    }

    func makeDarkTheme() -> ChatTheme {
        // переопределяем компоненты в теме
        let flow = ChatFlow(components: ChatComponents(images: darkImages,
                                                       colors: colors,
                                                       typography: typography))
        // меняем отображение аватаров
        flow.incomeMessages.showAvatar = showIncomeAvatar
        flow.outcomeMessages.showAvatar = showOutcomeAvatar
        return ChatTheme(flows: ChatFlows(chatFlow: flow))
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
        return images
    }
}
