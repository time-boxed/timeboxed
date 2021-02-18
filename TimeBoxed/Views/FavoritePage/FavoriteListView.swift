//
//  FavoriteListView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct GroupedFavorites: View {
    var groups: [(key: Project, value: [Favorite])]

    var body: some View {
        ForEach(groups, id: \.key) { project, favorites in
            Section(header: ProjectOptionalView(project: project)) {
                ForEach(favorites) { favorite in
                    NavigationLink(destination: FavoriteDetailView(favorite: favorite)) {
                        FavoriteRowView(favorite: favorite)
                    }
                }
            }
        }
    }

    init(favorites: [Favorite]) {
        self.groups = Dictionary(
            grouping: favorites.filter { $0.project != nil },
            by: { $0.project! }
        ).sorted { $0.key.name > $1.key.name }
    }
}

struct FavoriteListView: View {
    @EnvironmentObject var store: FavoriteStore

    @State private var isPresented = false
    @State private var data = Favorite.Data()

    var body: some View {
        NavigationView {
            List {
                AsyncContentView(source: store) { favorites in
                    GroupedFavorites(favorites: favorites)
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
