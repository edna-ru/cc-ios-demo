//
// Preferences.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import Foundation

public enum PreferencesKeys: String {
    case users = "Users"
    case servers = "Servers"
}

public final class Preferences {
    // MARK: Lifecycle

    init() {
        UserDefaults.standard.register(defaults: [PreferencesKeys.servers.rawValue: getServers()])
    }

    // MARK: Internal

    func get<T: Decodable>(type _: T.Type, forKey key: PreferencesKeys) -> T? {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data,
           let object = try? decoder.decode(T.self, from: data)
        {
            return object
        }

        return nil
    }

    func save(_ object: some Encodable, forKey key: PreferencesKeys) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(object) {
            UserDefaults.standard.set(data, forKey: key.rawValue)
        }
    }

    func getServers() -> Data {
        guard
            let url = Bundle.main.url(forResource: "servers", withExtension: "json"),
            let jsonData = try? Data(contentsOf: url)
        else {
            return Data()
        }

        return jsonData
    }
}
