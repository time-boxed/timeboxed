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

    var favorite: Favorite

    var body: some View {
        List {
            Text(favorite.title)
            Text("\(favorite.count)")
            Link(favorite.html_link.absoluteString, destination: favorite.html_link)
            Button("Start", action: actionStart)
        }
        .navigationBarTitle(favorite.title)
    }

    func actionStart() {
        store.start(favorite: favorite) { pomodoro in
            user.currentTab = .countdown
        }
    }
}

//struct FavoriteDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteDetailView()
//    }
//}
