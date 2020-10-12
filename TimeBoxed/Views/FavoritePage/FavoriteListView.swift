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

    var body: some View {
        NavigationView {
            List {
                AsyncContentView(source: store) { favorites in
                    Section {
                        ForEach(favorites) { item in
                            NavigationLink(destination: FavoriteDetailView(favorite: item)) {
                                FavoriteRowView(favorite: item)
                            }
                        }
                    }
                }
                ReloadButton(source: store)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Favorites")
            .navigationBarItems(
                leading: EditButton(),
                trailing: AddFavoriteButton()
            )
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
