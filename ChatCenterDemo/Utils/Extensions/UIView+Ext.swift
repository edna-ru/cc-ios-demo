//
// UIView+Ext.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import UIKit

public extension UIView {
    var safeArea: UILayoutGuide { safeAreaLayoutGuide }

    func roundView(radius: CGFloat, borderColor: UIColor = .clear, borderWidth: CGFloat = 0) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = radius
        clipsToBounds = true
    }

    func setShadow(offset: CGSize = CGSize(width: 0, height: 6),
                   nameColor: String = "Shadow",
                   shadowOpacity: Float = 1,
                   shadowRadius: CGFloat = 2)
    {
        layer.shadowOffset = offset
        layer.shadowColor = UIColor(named: nameColor)?.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }

    func removeShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.clear.cgColor
        layer.cornerRadius = 0.0
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 0.0
    }
}
