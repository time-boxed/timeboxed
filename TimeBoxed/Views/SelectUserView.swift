//
//  SelectUserView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/31.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct SelectUserView: View {
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        List {
            ForEach(userSettings.users, id: \.self) { user in
                Button(action: {
                    self.userSettings.current_user = user
                }) {
                    Text(user)
                }
            }.onDelete(perform: deleteItems)
        }
        .navigationBarItems(trailing: EditButton())
    }

    func deleteItems(at offsets: IndexSet) {
        userSettings.users.remove(at: offsets)
    }
}

struct SelectUserView_Previews: PreviewProvider {
    static var previews: some View {
        SelectUserView()
    }
}

extension Array {
    mutating func remove(at set: IndexSet) {
        var arr = Swift.Array(self.enumerated())
        arr.removeAll { set.contains($0.offset) }
        self = arr.map { $0.element }
    }
}
