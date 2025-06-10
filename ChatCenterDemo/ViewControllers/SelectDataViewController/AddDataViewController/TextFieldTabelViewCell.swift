//
// TextFieldTabelViewCell.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import UIKit

public enum TypeField {
    case text
    case url
    case number
}

final class TextFieldTabelViewCell: UITableViewCell {
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    override var canBecomeFirstResponder: Bool { true }

    func setupCell(type: TypeField, text: String? = "", placeholder: String = "") {
        switch type {
        case .text:
            textField.keyboardType = .default
        case .url:
            textField.keyboardType = .URL
        case .number:
            textField.keyboardType = .numberPad
        }
        if !placeholder.isEmpty {
            textField.placeholder = placeholder
        }
        textField.text = text
    }

    func getTextFieldValue() -> String {
        textField.text ?? ""
    }

    func configureViews() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none

        contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
    }

    // MARK: Private

    private var textField = UITextField()
}

// MARK: UITextViewDelegate

extension TextFieldTabelViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
