//
// SelectedButton.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import UIKit

open class SelectedButton: UIButton {
    // MARK: Open

    override open var isEnabled: Bool {
        didSet {
            setActiveDesign(isEnabled)
        }
    }

    // MARK: Internal

    var normalColor = UIColor(named: "MainColor")

    var isValue: Bool = false {
        didSet {
            if isValue {
                setSelectedValueDesign()
            } else {
                setActiveDesign(isEnabled)
            }
        }
    }

    func setup() {
        titleLabel?.font = .systemFont(ofSize: 14)
        setTitleColor(normalColor, for: .normal)
        contentHorizontalAlignment = .left
        heightAnchor.constraint(equalToConstant: 46).isActive = true
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        tintColor = UIColor(named: "SelectedButtonImageNormalColor")
        roundView(radius: 12)
        addTarget(self, action: #selector(holdDown), for: .touchDown)
        addTarget(self, action: #selector(holdUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(holdDragExit), for: .touchDragExit)
        addTarget(self, action: #selector(holdCancel), for: .touchCancel)
        setupImage()

        setActiveDesign(isEnabled)
    }

    func setActiveDesign(_ enabled: Bool = true) {
        if enabled {
            layer.borderWidth = 0.5
            layer.borderColor = UIColor.darkText.cgColor
            tintColor = UIColor(named: "SelectedButtonImageNormalColor")
            setTitleColor(UIColor.darkText, for: .normal)
            backgroundColor = UIColor.lightText
        } else {
            setTitleColor(UIColor(named: "MainButtonTitleDisableColor"), for: .normal)
            backgroundColor = UIColor(named: "SelectedButtonBackgroundDisableColor")
        }
    }

    func setSelectedValueDesign() {
        tintColor = UIColor(named: "SelectedButtonImageNormalColor")
        setTitleColor(UIColor(named: "MainButtonTintColor"), for: .normal)
        backgroundColor = UIColor(named: "SelectedButtonDisableColor")
    }

    @objc func holdDown() {
        tintColor = UIColor(named: "SelectedButtonImageNormalColor")
        setTitleColor(UIColor(named: "MainButtonBackgroundColor"), for: .normal)
        backgroundColor = UIColor(named: "BackgroundGrey")
    }

    @objc func holdUpInside() {
        holdRelease()
    }

    @objc func holdDragExit() {
        holdRelease()
    }

    @objc func holdCancel() {
        holdRelease()
    }

    // MARK: Private

    private let rightImageView = UIImageView()

    private func holdRelease() {
        UIView.animate(withDuration: 0.1) {
            if self.isValue {
                self.setSelectedValueDesign()
                return
            }
            self.tintColor = UIColor(named: "SelectedButtonImageNormalColor")
            self.setTitleColor(self.normalColor, for: .normal)
            self.backgroundColor = UIColor(named: "MainButtonDisabledColor")
        }
    }

    private func setupImage() {
        rightImageView.image = UIImage(named: "rightArrow")
        rightImageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(rightImageView)
        NSLayoutConstraint.activate([
            rightImageView.widthAnchor.constraint(equalToConstant: 16),
            rightImageView.heightAnchor.constraint(equalToConstant: 16),
            rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
