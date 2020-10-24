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
        case project
        case history
        case settings
        case report
    }

    @EnvironmentObject var userSettings: UserSettings
    @State private var showLogin = false

    var body: some View {
        TabView(selection: $userSettings.currentTab) {
            CountdownParentView()
                .tabItem { Label("Active", systemImage: "timer") }
                .tag(Tab.countdown)
            FavoriteListView()
                .tabItem { Label("Favorite", systemImage: "star") }
                .tag(Tab.favorites)
            ProjectListView()
                .tabItem { Label("Project", systemImage: "paperclip") }
                .tag(Tab.project)
            HistoryView()
                .tabItem { Label("History", systemImage: "calendar") }
                .tag(Tab.history)
            //            ReportView()
            //                .tabItem{ Label("Report", systemImage: "list.star") }
            //                .tag(Tab.report)
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
                .tag(Tab.settings)

        }
        .sheet(isPresented: $showLogin) {
            LoginView()
                .environmentObject(self.userSettings)
        }
        .onAppear {
            self.showLogin = self.userSettings.current_user == nil
        }
    }
}

#if DEBUG
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView().previewDevice(PreviewData.device)
        }
    }

#endif
