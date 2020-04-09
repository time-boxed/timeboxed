//
//  Keychain+Extensions.swift
//  NextPomodoro
//
//  Created by Paul Traylor on 2020/01/16.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Foundation
import KeychainAccess

extension Keychain {
    func string(forKey key: Keychain.Keys) -> String? {
        return try? get(key.rawValue)
    }
    func string(for name: String) -> String? {
        return try? get(name)
    }
    func set(_ value: String, for name: String) {
        try? set(value, key: name)
    }

    func set(_ value: String, forKey key: Keychain.Keys) {
        try? set(value, key: key.rawValue)
    }
}
