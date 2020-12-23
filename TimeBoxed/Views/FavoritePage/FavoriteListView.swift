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
    @EnvironmentObject var store: FavoriteStore

    @State private var isPresented = false
    @State private var data = Favorite.Data()

    var body: some View {
        NavigationView {
            List {
                AsyncContentView(source: store) { favorites in
                    Section {
                        ForEach(favorites) { item in
                            NavigationLink(destination: FavoriteDetailView(favorite: item)) {
                                FavoriteRowView(favorite: item)
                            }
                        }.onDelete(perform: store.delete)
                    }
                }

            }
            .listStyle(GroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add", action: actionShowAdd)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    ReloadButton(source: store)
                }
            }
            .navigationBarTitle("Favorites")
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    FavoriteEditView(favorite: $data)
                        .navigationTitle("New Favorite")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel", action: actionCancelEdit)
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done", action: actionSaveEdit)
                            }
                        }
                }
            }
        }
    }

    private func actionShowAdd() {
        isPresented = true
        data = .init()
    }

    private func actionCancelEdit() {
        isPresented = false
    }

    private func actionSaveEdit() {
        store.create(data) { newFavorite in
            isPresented = false
            store.load()
        }
    }
}

#if DEBUG
    struct FavoriteView_Previews: PreviewProvider {
        static var previews: some View {
            FavoriteListView().previewDevice(PreviewData.device)
        }
    }
#endif
