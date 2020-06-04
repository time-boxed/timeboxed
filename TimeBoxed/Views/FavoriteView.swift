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
    @ObservedObject var store = FavoriteStore()
    @Binding var selection: ContentView.Tab

    var body: some View {
        List {
            ForEach(store.favorites) { item in
                FavoriteRowView(favorite: item)
                    .onLongPressGesture {
                        self.store.start(favorite: item) { pomodoro in
                            self.selection = .countdown
                        }
                    }
            }
        }
        .onAppear(perform: store.fetch)
        .listStyle(GroupedListStyle())
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var device = PreviewDevice(rawValue: "iPhone SE")
    static var previews: some View {
        FavoriteView(selection: .constant(.favorites)).previewDevice(device)
    }
}
