//
//  Settings.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Foundation
import KeychainAccess

extension UserDefaults {
    enum Keys: String {
        case currentUser
        case users
    }
}

extension Keychain {
    enum Keys: String {
        case server
        case broker
    }
}

struct Settings {
    static let identifier = "net.kungfudiscomonkey.Timebox"
    static let defaults = UserDefaults(suiteName: Settings.identifier)!
    static let keychain = Keychain(service: Settings.identifier)
    static let homepage = URL(string: "https://github.com/kfdm/timeboxed")!
}
