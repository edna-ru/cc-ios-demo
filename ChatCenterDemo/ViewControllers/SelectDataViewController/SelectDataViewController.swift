//
// SelectDataViewController.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import UIKit

public enum SelectDataViewControllerType {
    case server
    case user
}

final class SelectDataViewController: UIViewController {
    // MARK: Lifecycle

    init(_ type: SelectDataViewControllerType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    /// Для обработки удаления пользователя
    var logoutHandler: ((DemoUser) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.backgroundColor = .secondarySystemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonItemTap))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSettings()
        containerTableView.reloadData()
    }

    @objc func rightBarButtonItemTap() {
        navigationController?.pushViewController(AddDataViewController(type), animated: true)
    }

    func setupSettings() {
        switch type {
        case .server:
            title = "Сервера"
            imageName = "serverImage"
            infoLabelText = "Добавьте данные вашего сервера для подключения к чату."
            textButton = "Добавить демо сервер"
            let servers = Preferences().get(type: [Server].self, forKey: .servers) ?? []
            if servers.isEmpty {
                setupContainerView()
                containerView.isHidden = false
                containerTableView.isHidden = true
                return
            }
        case .user:
            title = "Пользователи"
            imageName = "userImage"
            infoLabelText = "Добавьте нового пользователя для подключения к чату."
            textButton = "Добавить нового пользователя"
            let users = Preferences().get(type: [DemoUser].self, forKey: .users) ?? []
            if users.isEmpty {
                setupContainerView()
                containerView.isHidden = false
                containerTableView.isHidden = true
                return
            }
        }
        setupTabelView()
        containerView.isHidden = true
        containerTableView.isHidden = false
    }

    func setupContainerView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeArea.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: view.safeArea.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.safeArea.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])

        setupImage()
        setupInfoLabel()
        setupMainButton()
    }

    func setupImage() {
        view.addSubview(imageView)
        imageView.image = UIImage(named: imageName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 274),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 127),
        ])
    }

    func setupInfoLabel() {
        infoLabel.font = .systemFont(ofSize: 12)
        infoLabel.textAlignment = .left
        infoLabel.numberOfLines = 0
        infoLabel.textColor = UIColor(named: "MainButtonTintColor") ?? .white
        infoLabel.text = infoLabelText
        infoLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 36),
            infoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 28),
            infoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -28),
        ])
    }

    func setupMainButton() {
        mainButton.setActiveDesign()
        mainButton.setup()
        mainButton.addTarget(self, action: #selector(rightBarButtonItemTap), for: .touchUpInside)
        mainButton.setTitle(textButton, for: .normal)
        mainButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainButton)
        NSLayoutConstraint.activate([
            mainButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 24),
            mainButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            mainButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
        ])
    }

    func setupTabelView() {
        containerTableView.translatesAutoresizingMaskIntoConstraints = false
        containerTableView.setup(isSelectedViewController: true, type: type, viewController: self, removeOutput: self)

        view.addSubview(containerTableView)
        NSLayoutConstraint.activate([
            containerTableView.topAnchor.constraint(equalTo: view.safeArea.topAnchor, constant: 0),
            containerTableView.leadingAnchor.constraint(equalTo: view.safeArea.leadingAnchor, constant: 0),
            containerTableView.trailingAnchor.constraint(equalTo: view.safeArea.trailingAnchor, constant: 0),
            containerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }

    // MARK: Private

    private var type: SelectDataViewControllerType = .server
    private var textTitle = ""
    private var imageName = ""
    private var infoLabelText = ""
    private var textButton = ""

    private lazy var containerView: UIView = .init()
    private lazy var containerTableView = ContainerTableView()

    private var imageView = UIImageView()
    private var infoLabel = UILabel()
    private var mainButton = MainButton()
}

// MARK: - DismissActionOutput

extension SelectDataViewController: RemoveActionOutput {
    func removeAll() {
        setupContainerView()
        containerView.isHidden = false
        containerTableView.isHidden = true
    }

    func removedUser(_ user: DemoUser) {
        logoutHandler?(user)
    }
}
