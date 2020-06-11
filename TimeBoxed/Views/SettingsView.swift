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
                    OpenLinkView(url: Settings.homepage)
                }
                Section(header: Text("User")) {
                    NavigationLink(destination: LoginView()) {
                        Text("New User")
                    }
                    NavigationLink(destination: SelectUserView()) {
                        NameValueView(
                            name: "Current User",
                            value: userSettings.current_user ?? "Not logged in")
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
