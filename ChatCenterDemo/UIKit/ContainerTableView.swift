//
// ContainerTableView.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import UIKit

protocol RemoveActionOutput: AnyObject {
    func removeAll()
    func removedUser(_ user: DemoUser)
}

final class ContainerTableView: UIView {
    // MARK: Internal

    func setup(isSelectedViewController: Bool = false,
               type: SelectDataViewControllerType = .server,
               index: Int = -1,
               viewController: UIViewController? = nil,
               isSelected: Bool = false,
               removeOutput: RemoveActionOutput? = nil)
    {
        self.isSelectedViewController = isSelectedViewController
        self.type = type
        self.index = index
        self.viewController = viewController
        self.isSelected = isSelected
        self.removeOutput = removeOutput

        backgroundColor = UIColor(named: "BackgroundScreenColor") ?? .white

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(named: "MainButtonDisabledColor") ?? .white
        tableView.register(SelectedTableViewCell.self, forCellReuseIdentifier: "selectedCell")
        tableView.register(TextFieldTabelViewCell.self, forCellReuseIdentifier: "textFieldCell")
        tableView.keyboardDismissMode = .interactive
        tableView.translatesAutoresizingMaskIntoConstraints = false

        users = Preferences().get(type: [DemoUser].self, forKey: .users) ?? []
        servers = Preferences().get(type: [Server].self, forKey: .servers) ?? []

        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }

    func reloadData() {
        tableView.reloadData()
    }

    func actionNavigationRightBarButtonItem() {
        switch type {
        case .server:
            if allCells[1].getTextFieldValue().isEmpty, allCells[2].getTextFieldValue().isEmpty,
               allCells[3].getTextFieldValue().isEmpty, allCells[4].getTextFieldValue().isEmpty
            {
                viewController?.validErrorFields()
                return
            }
            guard
                let webSocketURL = URL(string: allCells[2].getTextFieldValue()),
                let restURL = URL(string: allCells[3].getTextFieldValue()),
                let dataStoreURL = URL(string: allCells[4].getTextFieldValue())
            else {
                viewController?.validErrorFields()
                return
            }
            var server = Server(name: allCells[0].getTextFieldValue(),
                                webSocketURL: webSocketURL.absoluteString,
                                providerUid: allCells[1].getTextFieldValue(),
                                restURL: restURL.absoluteString,
                                dataStoreURL: dataStoreURL.absoluteString,
                                appMarker: allCells[5].getTextFieldValue())

            if index != -1 {
                server.isSelected = isSelected
                servers[index] = server
            } else {
                servers.append(server)
            }
            Preferences().save(servers, forKey: .servers)
        case .user:
            if allCells[0].getTextFieldValue().isEmpty {
                viewController?.validErrorFields()
                return
            }
            var user = DemoUser(id: allCells[0].getTextFieldValue(),
                                name: allCells[1].getTextFieldValue(),
                                data: allCells[2].getTextFieldValue().toDictionary,
                                signature: allCells[3].getTextFieldValue(),
                                authToken: allCells[4].getTextFieldValue(),
                                authSchema: allCells[5].getTextFieldValue(),
                                authMethod: allCells[6].getTextFieldValue())
            if index != -1 {
                user.isSelected = isSelected
                users[index] = user
            } else {
                users.append(user)
            }
            Preferences().save(users, forKey: .users)
        }
        viewController?.navigationController?.popViewController(animated: true)
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Private

    private var tableView = UITableView(frame: CGRect(), style: .grouped)
    private var isSelectedViewController = false
    private var type: SelectDataViewControllerType = .server

    private var users: [DemoUser] = []
    private var servers: [Server] = []
    private var allCells: [TextFieldTabelViewCell] = []
    private var index: Int = -1
    private var viewController: UIViewController?
    private var removeOutput: RemoveActionOutput?
    private var isSelected = false

    private func editDataShow(index: Int) {
        switch type {
        case .server:
            viewController?.navigationController?.pushViewController(AddDataViewController(.server,
                                                                                           index: index,
                                                                                           isSelected: servers[index].isSelected),
                                                                     animated: true)
        case .user:
            viewController?.navigationController?.pushViewController(AddDataViewController(.user,
                                                                                           index: index,
                                                                                           isSelected: users[index].isSelected),
                                                                     animated: true)
        }
    }
}

// MARK: UITableViewDataSource

extension ContainerTableView: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        if !isSelectedViewController, type == .server {
            return 2
        }
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection: Int) -> Int {
        /// экран добавления/редактирования
        if !isSelectedViewController {
            if type == .user {
                return 7
            }
            if numberOfRowsInSection == 0 {
                return 1
            }
            return 5
        }
        /// экран выбора - количество серверов/пользователей
        switch type {
        case .server:
            return servers.count
        case .user:
            return users.count
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat { 44 }

    fileprivate func editList(_ indexPath: IndexPath, _ cell: TextFieldTabelViewCell) {
        if tableView.numberOfSections > 1 {
            /// server
            if indexPath.section == 0 {
                cell.setupCell(type: .text, text: servers[index].name, placeholder: "Name")
            } else {
                switch indexPath.row {
                case 0:
                    cell.setupCell(type: .text, text: servers[index].providerUid, placeholder: "Provider UID")
                case 1:
                    cell.setupCell(type: .url, text: servers[index].webSocketURL, placeholder: "Websocket URL")
                case 2:
                    cell.setupCell(type: .url, text: servers[index].restURL, placeholder: "REST URL")
                case 3:
                    cell.setupCell(type: .url, text: servers[index].dataStoreURL, placeholder: "Data Store URL")
                case 4:
                    cell.setupCell(type: .text, text: servers[index].appMarker, placeholder: "App Marker")
                default:
                    cell.setupCell(type: .url)
                }
            }
        } else {
            /// user
            switch indexPath.row {
            case 0:
                cell.setupCell(type: .text, text: users[index].id, placeholder: "ID обязательный параметр")
            case 1:
                cell.setupCell(type: .text, text: users[index].name, placeholder: "Имя")
            case 2:
                let data = users[index].data ?? [:]
                let dataStr = data.map { "\"\($0.0)\"" + ":" + "\"\($0.1)\"" }.joined(separator: ",")
                cell.setupCell(type: .text, text: "{\(dataStr)}", placeholder: "Данные в формате {\"\":\"\", \"\":\"\"}")
            case 3:
                cell.setupCell(type: .text, text: users[index].signature, placeholder: "Подпись")
            case 4:
                cell.setupCell(type: .text, text: users[index].authToken, placeholder: "AuthToken")
            case 5:
                cell.setupCell(type: .text, text: users[index].authToken, placeholder: "AuthScheme")
            case 6:
                cell.setupCell(type: .number, text: users[index].authMethod, placeholder: "AuthMethod")
            default:
                cell.setupCell(type: .text)
            }
        }
    }

    fileprivate func createList(_ indexPath: IndexPath, _ cell: TextFieldTabelViewCell) {
        if tableView.numberOfSections > 1 {
            /// server
            if indexPath.section == 0 {
                cell.setupCell(type: .text, placeholder: "Name")
            } else {
                switch indexPath.row {
                case 0:
                    cell.setupCell(type: .text, placeholder: "Provider UID")
                case 1:
                    cell.setupCell(type: .url, placeholder: "Websocket URL")
                case 2:
                    cell.setupCell(type: .url, placeholder: "REST URL")
                case 3:
                    cell.setupCell(type: .url, placeholder: "Data Store URL")
                case 4:
                    cell.setupCell(type: .text, placeholder: "App Marker")
                default:
                    cell.setupCell(type: .url)
                }
            }
        } else {
            /// user
            switch indexPath.row {
            case 0:
                cell.setupCell(type: .text, placeholder: "ID обязательный параметр")
            case 1:
                cell.setupCell(type: .text, placeholder: "Имя")
            case 2:
                cell.setupCell(type: .text, placeholder: "Данные в формате {\"\":\"\", \"\":\"\"}")
            case 3:
                cell.setupCell(type: .text, placeholder: "Подпись")
            case 4:
                cell.setupCell(type: .text, placeholder: "AuthToken")
            case 5:
                cell.setupCell(type: .text, placeholder: "AuthScheme")
            case 6:
                cell.setupCell(type: .number, placeholder: "AuthMethod")
            default:
                cell.setupCell(type: .text)
            }
        }
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isSelectedViewController {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as? TextFieldTabelViewCell else {
                return UITableViewCell()
            }
            let isEdit = index > -1 ? true : false
            /// редактирование
            if isEdit {
                editList(indexPath, cell)
            } else {
                createList(indexPath, cell)
            }

            if !allCells.contains(cell) {
                allCells.append(cell)
            }

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectedCell", for: indexPath as IndexPath) as? SelectedTableViewCell else {
                return UITableViewCell()
            }
            switch type {
            case .server:
                let server = servers[indexPath.row]
                cell.setupCell(server.name, isSelected: server.isSelected)
            case .user:
                let user = users[indexPath.row]
                cell.setupCell(user.id, isSelected: user.isSelected)
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate

extension ContainerTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isSelectedViewController {
            switch type {
            case .server:
                for index in servers.indices {
                    servers[index].isSelected = false
                }
                servers[indexPath.row].isSelected = true
                Preferences().save(servers, forKey: .servers)
            case .user:
                for index in users.indices {
                    users[index].isSelected = false
                }
                users[indexPath.row].isSelected = true
                Preferences().save(users, forKey: .users)
            }
            viewController?.navigationController?.popViewController(animated: true)
            viewController?.dismiss(animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !isSelectedViewController {
            return UISwipeActionsConfiguration(actions: [])
        }
        let edit = UIContextualAction(style: .normal, title: "") { [weak self] _, _, completionHandler in
            self?.editDataShow(index: indexPath.row)
            completionHandler(true)
        }
        edit.backgroundColor = .systemBlue
        edit.image = UIImage(named: "pencil")

        let remove = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completionHandler in
            guard let self else {
                return
            }

            completionHandler(true)

            switch type {
            case .server:
                servers.remove(at: indexPath.row)
                Preferences().save(servers, forKey: .servers)
                if servers.isEmpty {
                    removeOutput?.removeAll()
                }
            case .user:
                removeOutput?.removedUser(users[indexPath.row])
                users.remove(at: indexPath.row)
                Preferences().save(users, forKey: .users)
                if users.isEmpty {
                    removeOutput?.removeAll()
                }
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        remove.image = UIImage(named: "trash")

        return UISwipeActionsConfiguration(actions: [remove, edit])
    }

    func tableView(_: UITableView, titleForFooterInSection _: Int) -> String? {
        switch type {
        case .user:
            "Значения AuthMethod: \n0 - headers (по умолчанию) \nлюбое другое - cookies"
        case .server:
            nil
        }
    }
}
