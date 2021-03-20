//
//  SelectUserView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/31.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct SelectUserView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        List {
            ForEach(store.state.users, id: \.self) { user in
                Button(action: { store.send(.setUser(user: user)) }) {
                    Text(user)
                }
            }.onDelete(perform: deleteItems)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
        }

    }

    func deleteItems(at offsets: IndexSet) {
        store.send(.userRemove(offset: offsets))
    }
}

struct SelectUserView_Previews: PreviewProvider {
    static var previews: some View {
        SelectUserView()
    }
}
