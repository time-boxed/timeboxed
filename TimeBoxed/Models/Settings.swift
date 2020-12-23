//
//  Settings.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import Foundation
import KeychainAccess
import SwiftUI

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
    fileprivate static let defaults = UserDefaults(suiteName: Settings.identifier)!
    static let keychain = Keychain(service: Settings.identifier)
}

class UserSettings: ObservableObject {
    @AppStorage("current_user") var current_user: Login?
    @AppStorage("users") var users: [Login] = []
    @Published var currentTab = ContentView.Tab.countdown

    let pomodoros = PomodoroStore()
    let favorites = FavoriteStore()
    let projects = ProjectStore()

    func load() {
        pomodoros.load()
        favorites.load()
        projects.load()
    }
}
