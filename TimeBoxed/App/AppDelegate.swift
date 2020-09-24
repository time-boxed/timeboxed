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
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(UserSettings())
                .environmentObject(ProjectStore())
                .environmentObject(PomodoroStore())
                .environmentObject(FavoriteStore())
        }
    }
}
