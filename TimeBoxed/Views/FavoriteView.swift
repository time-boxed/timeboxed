//
//  FavoriteView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var store = FavoriteStore()

    @Binding var selection: ContentView.Tab

    var body: some View {
        NavigationView {
            List {
                ForEach(store.favorites) { item in
                    NavigationLink(destination: FavoriteDetailView(favorite: item)) {
                        FavoriteRowView(favorite: item)
                    }
                    .onLongPressGesture {
                        self.store.start(favorite: item) { pomodoro in
                            self.selection = .countdown
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .onAppear(perform: store.fetch)
    }
}

#if DEBUG

    struct FavoriteView_Previews: PreviewProvider {
        static var previews: some View {
            FavoriteView(selection: .constant(.favorites)).previewDevice(PreviewData.device)
        }
    }

#endif
