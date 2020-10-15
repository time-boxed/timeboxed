//
//  SelectUserView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/31.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct SelectUserView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var pomodoro: PomodoroStore
    @EnvironmentObject var favorite: PomodoroStore
    @EnvironmentObject var project: PomodoroStore

    var body: some View {
        List {
            ForEach(settings.users, id: \.self) { user in
                Button(action: {
                    settings.current_user = user
                    pomodoro.load()
                    favorite.load()
                    project.load()
                    settings.currentTab = .countdown
                }) {
                    Text(user)
                }
            }.onDelete(perform: deleteItems)
        }
        .navigationBarItems(trailing: EditButton())
    }

    func deleteItems(at offsets: IndexSet) {
        settings.users.remove(atOffsets: offsets)
    }
}

struct SelectUserView_Previews: PreviewProvider {
    static var previews: some View {
        SelectUserView()
    }
}
