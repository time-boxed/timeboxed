//
//  FavoriteListView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

extension Array where Element == Favorite {
    var groupedCount: Int {
        self.reduce(0) { $0 + $1.count }
    }
}

struct FavoriteListProjects: View {
    @EnvironmentObject var store: AppStore
    private var groups: [(key: Project, value: [Favorite])]

    @ViewBuilder func header(project: Project, favorites: [Favorite]) -> some View {
        HStack {
            NavigationLink(destination: ProjectDetailView(project: project)) {
                ProjectOptionalView(project: project)
            }
            Spacer()
            Text("Count \(favorites.groupedCount)")
        }
    }

    var body: some View {
        ForEach(groups, id: \.key) { project, favorites in
            Section(header: header(project: project, favorites: favorites)) {
                ForEach(favorites) { favorite in
                    NavigationLink(destination: FavoriteDetailView(favorite: favorite)) {
                        FavoriteRowView(favorite: favorite)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Delete", role:.destructive) {
                            store.send(.favorite(.delete(delete: favorite)))
                        }
                        Button("Move") {

                        }
                        .tint(.blue)
                    }
                }
            }
        }
    }

    init(favorites: [Favorite]) {
        self.groups = Dictionary(
            grouping: favorites,
            by: { $0.project }
        ).sorted { $0.value.groupedCount > $1.value.groupedCount }
    }
}

struct FavoriteListSorted: View {
    @EnvironmentObject var store: AppStore
    private var favorites: [Favorite]

    var body: some View {
        ForEach(favorites) { favorite in
            NavigationLink(destination: FavoriteDetailView(favorite: favorite)) {
                FavoriteRowView(favorite: favorite, showProject: true)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button("Delete", role:.destructive) {
                    store.send(.favorite(.delete(delete: favorite)))
                }
                Button("Move") {

                }
                .tint(.blue)
            }
        }
    }
    init(byCount: [Favorite]) {
        self.favorites = byCount.sorted { $0.count > $1.count }
    }
    init(byTitle: [Favorite]) {
        self.favorites = byTitle.sorted { $0.title < $1.title }
    }
}

struct FavoriteListView: View {
    enum Sorting: String {
        case alphabetic
        case project
        case count
    }
    @EnvironmentObject var store: AppStore

    @State private var isPresented = false
    @State private var data = Favorite.Data()
    @AppStorage("favoriteSort") private var sorting = Sorting.alphabetic

    var body: some View {
        NavigationView {
            List {
                sorting.content(favorites: store.state.favorites)
            }
            .refreshable { await fetch() }
            .task { await fetch() }
            .listStyle(.grouped)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Add", action: actionShowAdd)
                    Picker("Sorting", selection: $sorting) {
                        Text("Alphabetic").tag(Sorting.alphabetic)
                        Text("Project").tag(Sorting.project)
                        Text("Count").tag(Sorting.count)
                    }.pickerStyle(.menu)
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
    private func fetch() async {
        store.send(.favorite(.fetch))
    }
    private func actionShowAdd() {
        isPresented = true
        data = .init()
    }

    private func actionCancelEdit() {
        isPresented = false
    }

    private func actionSaveEdit() {
        store.send(.favorite(.create(data: data)))
        isPresented = false
    }
}

extension FavoriteListView.Sorting {
    @ViewBuilder func content(favorites: [Favorite]) -> some View {
        switch self {
        case .alphabetic:
            FavoriteListSorted(byTitle: favorites)
        case .project:
            FavoriteListProjects(favorites: favorites)
        case .count:
            FavoriteListSorted(byCount: favorites)
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
