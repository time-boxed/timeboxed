//
//  SettingsView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/30.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
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
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
                        as? String,
                        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                    {
                        Label("Version \(version) Build: \(build)", systemImage: "note.text")
                    }

                }
                Section(header: Text("User")) {
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
