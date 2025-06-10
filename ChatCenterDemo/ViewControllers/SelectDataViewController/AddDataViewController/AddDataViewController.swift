//
// AddDataViewController.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import UIKit

final class AddDataViewController: UIViewController {
    // MARK: Lifecycle

    init(_ type: SelectDataViewControllerType, index: Int = -1, isSelected: Bool = false) {
        self.type = type
        self.isSelected = isSelected
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground

        if index > -1 {
            titleRightButton = "Сохранить"
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: titleRightButton, style: .plain, target: self, action: #selector(rightBarButtonItemTap))
        setup()
    }

    // MARK: Private

    private let containerTableView = ContainerTableView()
    private var type: SelectDataViewControllerType = .server
    private var isSelected = false
    private var titleRightButton = "Создать"
    private var index: Int = -1
}

// MARK: Actions

private extension AddDataViewController {
    @objc func rightBarButtonItemTap() {
        containerTableView.actionNavigationRightBarButtonItem()
    }
}

// MARK: Private methods

private extension AddDataViewController {
    func setup() {
        setupSettings()
        setupTabelView()
    }

    func setupSettings() {
        switch type {
        case .server:
            title = "Сервер"
        case .user:
            title = "Пользователь"
        }
    }

    func setupTabelView() {
        containerTableView.translatesAutoresizingMaskIntoConstraints = false
        containerTableView.setup(isSelectedViewController: false, type: type, index: index, viewController: self, isSelected: isSelected)

        view.addSubview(containerTableView)
        NSLayoutConstraint.activate([
            containerTableView.topAnchor.constraint(equalTo: view.safeArea.topAnchor, constant: 0),
            containerTableView.leadingAnchor.constraint(equalTo: view.safeArea.leadingAnchor, constant: 0),
            containerTableView.trailingAnchor.constraint(equalTo: view.safeArea.trailingAnchor, constant: 0),
            containerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
}
