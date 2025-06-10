//
// DemoUser.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import ChatCenterUI
import Foundation

/// Модель пользователя в демо приложении
public struct DemoUser: Codable {
    // MARK: Lifecycle

    init(
        id: String,
        name: String,
        data: [String: String]?,
        signature: String?,
        authToken: String?,
        authSchema: String?,
        authMethod: String = "0"
    ) {
        self.id = id
        self.name = name
        self.data = data
        self.signature = signature
        self.authToken = authToken
        self.authSchema = authSchema
        self.authMethod = authMethod
        isSelected = false
    }

    // MARK: Internal

    var id: String
    var name: String
    var data: [String: String]?
    var signature: String?
    var authToken: String?
    var authSchema: String?
    var authMethod: String
    var isSelected: Bool
}
