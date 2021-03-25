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

struct FavoriteHeader: View {
    var project: Project
    var favorites: [Favorite]

    var body: some View {
        HStack {
            NavigationLink(destination: ProjectDetailView(project: project)) {
                ProjectOptionalView(project: project)
            }
            Spacer()
            Text("Count \(favorites.groupedCount)")
        }
    }
}

struct FavoriteListProjects: View {
    var groups: [(key: Project, value: [Favorite])]

    var body: some View {
        ForEach(groups, id: \.key) { project, favorites in
            Section(header: FavoriteHeader(project: project, favorites: favorites)) {
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
            grouping: favorites,
            by: { $0.project }
        ).sorted { $0.value.groupedCount > $1.value.groupedCount }
    }
}

struct FavoriteListAlphabetic: View {
    var favorites: [Favorite]
    var body: some View {
        ForEach(favorites) { favorite in
            NavigationLink(destination: FavoriteDetailView(favorite: favorite)) {
                FavoriteRowView(favorite: favorite, showProject: true)
            }
        }
    }
    init(favorites: [Favorite]) {
        self.favorites = favorites.sorted { $0.title < $1.title }
    }
}

struct FavoriteListCount: View {
    var favorites: [Favorite]
    var body: some View {
        ForEach(favorites) { favorite in
            NavigationLink(destination: FavoriteDetailView(favorite: favorite)) {
                FavoriteRowView(favorite: favorite, showProject: true)
            }
        }
    }
    init(favorites: [Favorite]) {
        self.favorites = favorites.sorted { $0.count > $1.count }
    }
}

struct FavoriteListView: View {
    enum Sorting {
        case alphabetic
        case project
        case count
    }
    @EnvironmentObject var store: AppStore

    @State private var isPresented = false
    @State private var data = Favorite.Data()
    @State private var sorting = Sorting.alphabetic

    var content: some View {
        List {
            switch sorting {
            case .alphabetic:
                FavoriteListAlphabetic(favorites: store.state.favorites)
            case .project:
                FavoriteListProjects(favorites: store.state.favorites)
            case .count:
                FavoriteListCount(favorites: store.state.favorites)
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                content
            }
            .onAppear(perform: fetch)
            .listStyle(GroupedListStyle())
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Add", action: actionShowAdd)
                    Picker("Sorting", selection: $sorting) {
                        Text("Alphabetic").tag(Sorting.alphabetic)
                        Text("Project").tag(Sorting.project)
                        Text("Count").tag(Sorting.count)
                    }.pickerStyle(MenuPickerStyle())
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reload", action: fetch)
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
    func fetch() {
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

#if DEBUG
    struct FavoriteView_Previews: PreviewProvider {
        static var previews: some View {
            FavoriteListView().previewDevice(PreviewData.device)
        }
    }
#endif
