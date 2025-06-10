//
// BaseButtons.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import UIKit

// MARK: - MainButton

open class MainButton: BaseButton {
    // MARK: Open

    override open func setup() {
        titleLabel?.font = .boldSystemFont(ofSize: 14)
        setTitleColor(UIColor(named: "WhiteColor") ?? .white, for: .normal)

        super.setup()

        clipsToBounds = false

        badgeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeCountLabel.layer.cornerRadius = badgeCountLabel.bounds.size.height / 2
        badgeCountLabel.textAlignment = .center
        badgeCountLabel.layer.masksToBounds = true
        badgeCountLabel.textColor = .white
        badgeCountLabel.font = .systemFont(ofSize: 12)
        badgeCountLabel.backgroundColor = .systemRed
        badgeCountLabel.isHidden = true

        addSubview(badgeCountLabel)
        NSLayoutConstraint.activate([
            badgeCountLabel.leftAnchor.constraint(equalTo: rightAnchor, constant: -15),
            badgeCountLabel.topAnchor.constraint(equalTo: topAnchor, constant: -10),
            badgeCountLabel.widthAnchor.constraint(equalToConstant: 30),
            badgeCountLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    // MARK: Internal

    func setBadgeCount(_ count: Int) {
        guard count > 0 else {
            badgeCountLabel.isHidden = true
            return
        }

        badgeCountLabel.text = String(count)
        badgeCountLabel.isHidden = false
    }

    // MARK: Private

    private let badgeCountLabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
}

// MARK: - DemoButton

open class DemoButton: BaseButton {
    override open func setup() {
        titleLabel?.font = .boldSystemFont(ofSize: 17)
        setTitleColor(.systemBlue, for: .normal)
        titleColor = .systemBlue
        normalColor = nil
        holdDownBackgroundColor = UIColor(named: "BackgroundGrey")
        notActiveTitleColor = UIColor(named: "MainButtonTitleDisableColor")
        notActiveBackgroundColor = nil
        super.setup()
    }
}

// MARK: - BaseButton

open class BaseButton: UIButton {
    // MARK: Open

    override open var isEnabled: Bool {
        didSet {
            setActiveDesign(isEnabled)
        }
    }

    open var normalColor = UIColor(named: "MainButtonBackgroundColor")
    open var titleColor: UIColor = .init(named: "MainTitleColor") ?? .white
    open var holdDownBackgroundColor = UIColor(named: "MainButtonPressedColor")
    open var notActiveTitleColor = UIColor(named: "MainButtonTitleDisableColor")
    open var notActiveBackgroundColor = UIColor(named: "MainButtonDisabledColor")

    open func setup() {
        roundView(radius: 12)
        heightAnchor.constraint(equalToConstant: 46).isActive = true

        addTarget(self, action: #selector(holdDown), for: .touchDown)
        addTarget(self, action: #selector(holdUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(holdDragExit), for: .touchDragExit)
        addTarget(self, action: #selector(holdCancel), for: .touchCancel)
        setActiveDesign(isEnabled)
    }

    open func setActiveDesign(_ enabled: Bool = true) {
        if enabled {
            setTitleColor(titleColor, for: .normal)
            backgroundColor = normalColor
        } else {
            setTitleColor(notActiveTitleColor, for: .normal)
            backgroundColor = notActiveBackgroundColor
        }
    }

    @objc open func holdDown() {
        setTitleColor(titleColor, for: .normal)
        backgroundColor = holdDownBackgroundColor
    }

    @objc open func holdUpInside() {
        holdRelease()
    }

    @objc open func holdDragExit() {
        holdRelease()
    }

    @objc open func holdCancel() {
        holdRelease()
    }

    // MARK: Private

    private func holdRelease() {
        UIView.animate(withDuration: 0.1) {
            self.setTitleColor(self.titleColor, for: .normal)
            self.backgroundColor = self.normalColor
        }
    }
}
