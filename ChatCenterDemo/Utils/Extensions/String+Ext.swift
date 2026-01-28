//
// String+Ext.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import UIKit

extension String {
    func parse<T: Decodable>(to type: T.Type) -> T? {
        let data: Data = data(using: .utf8)!
        let decoder = JSONDecoder()

        do {
            return try decoder.decode(type, from: data)

        } catch {
            return nil
        }
    }

    var toDictionary: [String: String]? {
        let data = Data(utf8)
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                return dictionary as? [String: String]
            }
        } catch let error as NSError {
            print("Failed to coonvert: \(error.localizedDescription)")
        }
        return nil
    }
}
