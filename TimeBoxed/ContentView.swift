//
//  ContentView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    enum Tab {
        case countdown
        case favorites
        case history
        case settings
    }

    @ObservedObject var userSettings = UserSettings.instance
    @State private var currentTab = ContentView.Tab.countdown
    @State private var showLogin = false

    var body: some View {
        TabView(selection: $currentTab) {
            CountdownPageView()
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Active")
                    }
                }
                .tag(Tab.countdown)

            FavoriteView(selection: $currentTab)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Favorite")
                    }
                }
                .tag(Tab.favorites)

            HistoryView()
                .tabItem {
                    VStack {
                        Image("second")
                        Text("History")
                    }
                }
                .tag(Tab.history)
            SettingsView()
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Settings")
                    }
                }
                .tag(Tab.settings)

        }
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
        .onAppear {
            self.showLogin = self.userSettings.current_user == nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
