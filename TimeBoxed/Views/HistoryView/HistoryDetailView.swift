//
//  HistoryDetailView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/30.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ButtonRepeatPomodoro: View {
    @EnvironmentObject var store: PomodoroStore
    @EnvironmentObject var user: UserSettings

    var pomodoro: Pomodoro
    var body: some View {
        Button("Repeat", action: action)
    }

    func action() {
        let start = Date()
        let end = start.addingTimeInterval(pomodoro.start.distance(to: pomodoro.end))
        store.create(Pomodoro(id: 0, title: pomodoro.title, start: start, end: end)) {
            newPomodoro in
            user.currentTab = .countdown
        }
    }
}

struct ButtonUpdatePomodoro: View {
    @EnvironmentObject var user: UserSettings

    var pomodoro: Pomodoro
    var body: some View {
        Button("Update", action: action)
    }

    func action() {
        user.currentTab = .countdown
    }
}

struct ButtonDeletePomodoro: View {
    @EnvironmentObject var user: UserSettings

    var pomodoro: Pomodoro
    var body: some View {
        Button("Update", action: action)
    }

    func action() {
        user.currentTab = .countdown
    }
}

struct HistoryDetailView: View {
    @State var pomodoro: Pomodoro

    var body: some View {
        List {
            ProjectSelectorView(project: pomodoro.project) { project in
                pomodoro.project = project
            }
            HStack {
                DateTimeView(date: pomodoro.start)
                Spacer()
                DateTimeView(date: pomodoro.end)
            }
            if let url = pomodoro.url {
                Link("Open", destination: url)
            }
            TextEditor(text: $pomodoro.memo)
                .frame(height: 128)

            Section {
                ButtonRepeatPomodoro(pomodoro: pomodoro)
                    .buttonStyle(ActionButtonStyle())
                    .modifier(CenterModifier())
                ButtonUpdatePomodoro(pomodoro: pomodoro)
                    .buttonStyle(ActionButtonStyle())
                    .modifier(CenterModifier())
                ButtonDeletePomodoro(pomodoro: pomodoro)
                    .buttonStyle(DangerButtonStyle())
                    .modifier(CenterModifier())
            }
        }
        .navigationBarTitle(pomodoro.title)
        .listStyle(GroupedListStyle())
    }
}

#if DEBUG

    struct HistoryDetailView_Previews: PreviewProvider {
        static var previews: some View {
            HistoryDetailView(pomodoro: PreviewData.pomodoro)
        }
    }

#endif
