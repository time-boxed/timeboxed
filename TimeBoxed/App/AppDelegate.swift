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
    let store = AppStore(initialState: .init(), reducer: appReducer, environment: AppEnvironment())

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
