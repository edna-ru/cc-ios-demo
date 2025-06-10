//
// SelectedTableViewCell.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import UIKit

final class SelectedTableViewCell: UITableViewCell {
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

    func setupCell(_ text: String, isSelected: Bool) {
        leftLabel.text = text
        if isSelected {
            isSelectedImageView.image = UIImage(named: "checkMark")
        } else {
            isSelectedImageView.image = nil
        }
    }

    func configureViews() {
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.font = .systemFont(ofSize: 17)
        leftLabel.textAlignment = .left
        leftLabel.textColor = UIColor(named: "MainButtonTintColor") ?? .white

        isSelectedImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(leftLabel)
        contentView.addSubview(isSelectedImageView)

        NSLayoutConstraint.activate([
            leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            leftLabel.trailingAnchor.constraint(equalTo: isSelectedImageView.leadingAnchor, constant: -8),
            leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            isSelectedImageView.widthAnchor.constraint(equalToConstant: 16),
            isSelectedImageView.heightAnchor.constraint(equalToConstant: 16),
            isSelectedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            isSelectedImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    // MARK: Private

    private var leftLabel = UILabel()
    private let isSelectedImageView = UIImageView()
}
