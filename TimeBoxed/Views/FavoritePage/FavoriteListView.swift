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

    @Binding var selection: ContentView.Tab
    @State var isPresenting = false

    var fetchedView: some View {
        ForEach(store.favorites) { item in
            NavigationLink(destination: FavoriteDetailView(favorite: item)) {
                FavoriteRowView(favorite: item)
            }
            .onLongPressGesture {
                self.store.start(favorite: item) { pomodoro in
                    self.selection = .countdown
                }
            }
        }.onDelete(perform: store.delete)
    }

    var switchView: AnyView {
        switch store.state {
        case .empty:
            return Text("No Favorites").eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .fetching:
            return Text("Loading").eraseToAnyView()
        case .fetched:
            return
                fetchedView
                .eraseToAnyView()
        }
    }

    var body: some View {
        NavigationView {
            List {
                Button("Reload", action: store.fetch)
                Section() {
                    switchView
                }
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
        .sheet(isPresented: $isPresenting, onDismiss: store.reload) {
            SheetNewFavoriteView(isPresented: self.$isPresenting)
                .sheetWithDone(isPresented: self.$isPresenting)
        }
    }
}

#if DEBUG
    struct FavoriteView_Previews: PreviewProvider {
        static var previews: some View {
            FavoriteListView(selection: .constant(.favorites)).previewDevice(PreviewData.device)
        }
    }
#endif
