//
//  SelectUserView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/31.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct SelectUserView: View {
    @ObservedObject var userSettings = UserSettings.instance

    var body: some View {
        List {
            ForEach(userSettings.users, id: \.self) { user in
                Button(action: {
                    self.userSettings.current_user = user
                }) {
                    Text(user)
                }
            }
        }
    }
}

struct SelectUserView_Previews: PreviewProvider {
    static var previews: some View {
        SelectUserView()
    }
}
