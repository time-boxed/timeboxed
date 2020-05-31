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
                NavigationLink(destination: EmptyView()) {
                    Text(Settings.homepage.absoluteString)
                }.onTapGesture(perform: openRepo)

                Text("Another Test")
            }
        }
    }
    
    func openRepo() {
        UIApplication.shared.open(Settings.homepage, options: [:], completionHandler: nil)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
