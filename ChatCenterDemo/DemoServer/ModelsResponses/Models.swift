//
// Models.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import Foundation

struct Action: Codable {
    var action: String
    var correlationId: String
    var data: Content?
}

struct Content: Codable {
    var content: ContentModel?
    var deviceAddress: String?
    var important: String?
}

struct ContentModel: Codable {
    var type: String?
    var deviceAddress: String?
    var uuid: String?
    var sentAt: String?
    var text: String?
    var clientId: String?
}
