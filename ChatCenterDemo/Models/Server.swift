//
// Server.swift
// ChatCenterDemo
//
// Copyright © 2026 edna. All rights reserved.
//

import Foundation

public struct Server: Codable, Hashable {
    var name: String
    var isSelected: Bool = false
    var webSocketURL: String
    var providerUid: String
    var restURL: String
    var dataStoreURL: String
    var appMarker: String?
    var apiVersion: UInt = 17
}
