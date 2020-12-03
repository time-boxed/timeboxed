//
//  FavoriteDetailView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/11.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct FavoriteDetailView: View {
    @EnvironmentObject var store: FavoriteStore
    @EnvironmentObject var user: UserSettings

    @State var favorite: Favorite

    var body: some View {
        List {
            Section {
                TextField("Title", text: $favorite.title)
                    .label(left: "Title")
                Text("\(favorite.count)")
                    .label(left: "Count")
                ProjectSelectorView(project: favorite.project) { project in
                    favorite.project = project
                }
                Link(favorite.html_link.absoluteString, destination: favorite.html_link)
            }

            Button("Start", action: actionStart)
                .buttonStyle(ActionButtonStyle())
                .modifier(CenterModifier())
            Button("Update", action: actionUpdate)
                .buttonStyle(ActionButtonStyle())
                .modifier(CenterModifier())
                .disabled(
                    [
                        favorite.title.count > 0
                    ].contains(false))

        }
        .navigationBarTitle(favorite.title)
        .listStyle(GroupedListStyle())
    }

    func actionStart() {
        store.start(favorite: favorite) { pomodoro in
            user.currentTab = .countdown
        }
    }

    func actionUpdate() {
        store.update(favorite: favorite) { (newFavorite) in
            store.load()
        }
    }
}

//struct FavoriteDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteDetailView()
//    }
//}
