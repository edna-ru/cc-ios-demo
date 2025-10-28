//
// String+Ext.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import UIKit

extension String {
    func parse<T>(to type: T.Type) -> T? where T: Decodable {
        let data: Data = data(using: .utf8)!
        let decoder = JSONDecoder()

        do {
            let object = try decoder.decode(type, from: data)
            return object

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
