//
//  SettingsView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/30.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

extension Bundle {
    var version: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    var build: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
}

struct SettingsView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Information")) {
                    Link(destination: URL(string: "https://github.com/kfdm/timeboxed")!) {
                        Label("Homepage", systemImage: "house")
                    }
                    Link(destination: URL(string: "https://github.com/kfdm/timeboxed/issues")!) {
                        Label("Issues", systemImage: "ant")
                    }
                    Label("Version \(Bundle.main.version) Build: \(Bundle.main.build)", systemImage: "note.text")
                }
                Section(header: Text(store.state.login ?? "Logged Out")) {
                    NavigationLink(destination: LoginView()) {
                        Label("New User", systemImage: "person.badge.plus")
                    }
                    NavigationLink(destination: SelectUserView()) {
                        Label("Switch User", systemImage: "person.2")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
