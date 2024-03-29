//
//  CountdownExtendView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

extension AppStore {
    fileprivate func sendDate(id: Int, date: Date) {
        send(.history(.date(id: id, date: date)))
    }
}

struct CountdownExtendView: View {
    var pomodoro: Pomodoro

    @EnvironmentObject var store: AppStore
    @State private var showEdit = false

    var body: some View {
        Section(header: Text("Extend")) {
            Button(action: actionAddPomodoro) {
                Label("25 min", systemImage: "clock")
            }
            .buttonStyle(ActionButtonStyle())
            .modifier(CenterModifier())

            Button(action: actionAddHour) {
                Label("60 min", systemImage: "clock")
            }
            .buttonStyle(ActionButtonStyle())
            .modifier(CenterModifier())

            Button(action: actionStop) {
                Label("Stop", systemImage: "nosign")
            }
            .buttonStyle(DangerButtonStyle())
            .modifier(CenterModifier())
        }
    }

    private func actionAddPomodoro() {
        store.sendDate(id: pomodoro.id, date: pomodoro.end.addingTimeInterval(25 * 60))
    }

    private func actionAddHour() {
        store.sendDate(id: pomodoro.id, date: pomodoro.end.addingTimeInterval(60 * 60))
    }

    private func actionStop() {
        store.sendDate(id: pomodoro.id, date: Date())
    }
}

#if DEBUG

    struct ExtendPomodoroView_Previews: PreviewProvider {

        static var previews: some View {
            CountdownExtendView(pomodoro: PreviewData.pomodoro)
        }
    }

#endif
