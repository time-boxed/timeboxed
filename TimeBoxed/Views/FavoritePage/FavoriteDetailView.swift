//
//  FavoriteDetailView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/11.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct FavoriteDetailView: View {
    @State var favorite: Favorite

    @State private var isPresented = false
    @State private var data = Favorite.Data()

    @EnvironmentObject var store: AppStore
    @EnvironmentObject var user: UserSettings
    @EnvironmentObject var main: PomodoroStore

    var body: some View {
        Group {
            List {
                Section {
                    Text(favorite.title)
                        .label(left: "Title")
                    Text("\(favorite.count)")
                        .label(left: "Count")
                    if let project = favorite.project {
                        ProjectRowView(project: project)
                    }
                    if let url = favorite.url {
                        Link(destination: url) {
                            Label(url.absoluteString, systemImage: "safari")
                        }
                    }
                    Link(destination: favorite.html_link) {
                        Label(favorite.html_link.absoluteString, systemImage: "link")
                    }
                }
                if let memo = favorite.memo {
                    Section(header: Text("Memo")) {
                        Text(memo)
                    }
                }
            }
            .navigationBarTitle(favorite.title)
            .listStyle(GroupedListStyle())

            Button("Start", action: actionStart)
                .buttonStyle(ActionButtonStyle())
                .modifier(CenterModifier())

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit", action: actionShowEdit)
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationView {
                FavoriteEditView(favorite: $data)
                    .navigationTitle(favorite.title)
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

    func actionStart() {
        store.send(.startFavorite(param: favorite))
    }

    func actionShowEdit() {
        isPresented = true
        data = favorite.data
    }

    func actionCancelEdit() {
        isPresented = false
    }

    func actionSaveEdit() {
        favorite.update(from: data)
        store.update(favorite: favorite) { _ in
            isPresented = false
            store.load()
        }
    }
}

#if DEBUG
    struct FavoriteDetailView_Previews: PreviewProvider {
        static var previews: some View {
            FavoriteDetailView(favorite: PreviewData.favorite)
                .previewLayout(.sizeThatFits)
        }
    }
#endif
