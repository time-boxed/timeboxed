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

    @State var isPresenting = false

    var fetchedView: some View {
        Section {
            ForEach(store.favorites) { item in
                NavigationLink(destination: FavoriteDetailView(favorite: item)) {
                    FavoriteRowView(favorite: item)
                }
            }.onDelete(perform: store.delete)
        }
    }

    var stateStatus: AnyView {
        switch store.state {
        case .empty:
            return Text("No result").eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .fetching:
            return Text("Loading").eraseToAnyView()
        case .fetched:
            return EmptyView().eraseToAnyView()
        }
    }

    var body: some View {
        NavigationView {
            List {
                HStack {
                    Button("Reload", action: store.fetch)
                    Spacer()
                    stateStatus
                }
                fetchedView
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Favorites")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: { self.isPresenting.toggle() }) {
                    Text("Add")
                })
        }
        .onAppear(perform: store.fetch)
        .sheet(isPresented: $isPresenting, onDismiss: store.reload) {
            SheetNewFavoriteView(isPresented: self.$isPresenting)
                .sheetWithDone(isPresented: self.$isPresenting)
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
