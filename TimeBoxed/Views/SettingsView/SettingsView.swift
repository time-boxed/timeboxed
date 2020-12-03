//
//  SettingsView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/30.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Information")) {
                    Link("Homepage", destination: URL(string: "https://github.com/kfdm/timeboxed")!)
                    Link(
                        "Issues",
                        destination: URL(string: "https://github.com/kfdm/timeboxed/issues")!)
                }
                Section(header: Text("User")) {
                    NavigationLink(destination: LoginView()) {
                        Text("New User")
                    }
                    NavigationLink(destination: SelectUserView()) {
                        Text(userSettings.current_user ?? "Not logged in")
                            .label(left: "Current User")
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
