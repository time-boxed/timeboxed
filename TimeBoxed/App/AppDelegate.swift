//
//  AppDelegate.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

@main
struct TimeBoxedApp: App {
    var user = UserSettings()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
                .environmentObject(user.favorites)
                .environmentObject(user.pomodoros)
                .environmentObject(user.projects)
        }
    }
}
