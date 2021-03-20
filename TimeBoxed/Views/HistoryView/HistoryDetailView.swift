//
//  HistoryDetailView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/30.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ButtonRepeatPomodoro: View {
    @EnvironmentObject var store: AppStore

    var pomodoro: Pomodoro
    var body: some View {
        Button(action: action) {
            Label("Repeat", systemImage: "repeat")
        }
    }

    func action() {
        let start = Date()
        let end = start.addingTimeInterval(pomodoro.start.distance(to: pomodoro.end))
        let newPomodoro = Pomodoro(id: 0, title: pomodoro.title, start: start, end: end)
        store.send(.historyCreate(data: newPomodoro))
    }
}

struct ButtonDeletePomodoro: View {
    @EnvironmentObject var store: AppStore

    var pomodoro: Pomodoro
    var body: some View {
        Button(action: action) {
            Label("Delete", systemImage: "trash")
        }
    }

    func action() {
        // TODO: Not yet implemented
        store.send(.tabSet(tab: .countdown))
    }
}

struct HistoryDetailView: View {
    @State var pomodoro: Pomodoro

    @State private var isPresented = false
    @State private var data = Pomodoro.Data()
    @EnvironmentObject var store: AppStore

    var body: some View {
        List {
            Section {
                ProjectOptionalView(project: pomodoro.project)
                HStack {
                    DateTimeView(date: pomodoro.start)
                    Spacer()
                    DateTimeView(date: pomodoro.end)
                }
                if let url = pomodoro.url {
                    Link(url.absoluteString, destination: url)
                }
            }

            Section(header: Text("Memo")) {
                Text(pomodoro.memo)
            }

            Section {
                ButtonRepeatPomodoro(pomodoro: pomodoro)
                    .buttonStyle(ActionButtonStyle())
                    .modifier(CenterModifier())
                ButtonDeletePomodoro(pomodoro: pomodoro)
                    .buttonStyle(DangerButtonStyle())
                    .modifier(CenterModifier())
            }
        }
        .navigationBarTitle(pomodoro.title)
        .listStyle(GroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit", action: actionShowEdit)
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationView {
                HistoryEditView(history: $data)
                    .navigationTitle(pomodoro.title)
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

    func actionShowEdit() {
        isPresented = true
        data = pomodoro.data
    }

    func actionCancelEdit() {
        isPresented = false
    }

    func actionSaveEdit() {
        pomodoro.update(from: data)
        store.send(.historyUpdate(data: pomodoro))
        isPresented = false
    }
}

#if DEBUG

    struct HistoryDetailView_Previews: PreviewProvider {
        static var previews: some View {
            HistoryDetailView(pomodoro: PreviewData.pomodoro)
        }
    }

#endif
