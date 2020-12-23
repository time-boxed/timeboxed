//
//  HistoryEditView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/12/07.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct EditHistoryButton: View {
    @State var pomodoro: Pomodoro
    @State var showEdit = false
    var body: some View {
        Button(action: { showEdit = true }) {
            Label("Edit", systemImage: "pencil")
        }
        .sheet(isPresented: $showEdit) {
            NavigationView {
                HistoryEditViewOld(pomodoro: pomodoro)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel", action: { showEdit = false })
                        }
                    }
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct HistoryEditViewOld: View {
    @State var pomodoro: Pomodoro
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: PomodoroStore

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $pomodoro.title)
                ProjectSelectorView(project: pomodoro.project) { project in
                    pomodoro.project = project
                }
                HStack {
                    DatePicker("Start", selection: $pomodoro.start)
                        .datePickerStyle(WheelDatePickerStyle())
                    Spacer()
                    DatePicker("End", selection: $pomodoro.end)
                        .datePickerStyle(WheelDatePickerStyle())
                }
            }

            Section(header: Text("Memo")) {
                TextEditor(text: $pomodoro.memo)
                    .frame(height: 128)
            }
        }
        .navigationTitle(pomodoro.title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Update", action: actionUpdate)
            }
        }
    }

    func actionUpdate() {
        store.update(object: pomodoro) { newPomodoro in
            store.load()
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct EditHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryEditViewOld(pomodoro: PreviewData.pomodoro)
    }
}
