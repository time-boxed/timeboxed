//
//  ContentView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @State private var showLogin = false
    @State private var currentUser = Settings.defaults.string(forKey: .currentUser)
    
    @ViewBuilder
    var body: some View {
        TabView(selection: $selection) {
            CountdownPageView()
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Active")
                    }
            }
            .tag(0)
            FavoriteView()
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Favorite")
                    }
            }
            .tag(1)
            HistoryView()
                .tabItem {
                    VStack {
                        Image("second")
                        Text("History")
                    }
            }
            .tag(2)
        }
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
        .onAppear {
            self.showLogin = self.currentUser == nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
