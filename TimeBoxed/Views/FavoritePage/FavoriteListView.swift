//
//  FavoriteListView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct FavoriteListView: View {
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var store = FavoriteStore()

    @Binding var selection: ContentView.Tab
    @State var isPresenting = false

    var body: some View {
        NavigationView {
            List {
                Button("Reload", action: store.fetch)

                ForEach(store.favorites) { item in
                    NavigationLink(destination: FavoriteDetailView(favorite: item)) {
                        FavoriteRowView(favorite: item)
                    }
                    .onLongPressGesture {
                        self.store.start(favorite: item) { pomodoro in
                            self.selection = .countdown
                        }
                    }
                }.onDelete(perform: deleteFavorite)
            }
            .onAppear(perform: store.fetch)
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Favorites")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: { self.isPresenting.toggle() }) {
                    Text("Add")
                })
        }

        .sheet(isPresented: $isPresenting) {
            SheetNewFavoriteView(isPresented: self.$isPresenting)
                .sheetWithDone(isPresented: self.$isPresenting)
        }
    }

    func deleteFavorite(at offset: IndexSet) {
        print(offset.rangeView)
    }
}

#if DEBUG

    struct FavoriteView_Previews: PreviewProvider {
        static var previews: some View {
            FavoriteListView(selection: .constant(.favorites)).previewDevice(PreviewData.device)
        }
    }

#endif
