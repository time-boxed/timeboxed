//
//  CountdownExtendView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct CountdownExtendView: View {
    var pomodoro: Pomodoro

    @EnvironmentObject var store: AppStore
    @State var showEdit = false

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

    func actionAddPomodoro() {
        store.send(.history(.date(id: pomodoro.id, date: pomodoro.end.addingTimeInterval(25 * 60))))
    }

    func actionAddHour() {
        store.send(.history(.date(id: pomodoro.id, date: pomodoro.end.addingTimeInterval(60 * 60))))
    }

    func actionStop() {
        store.send(.history(.date(id: pomodoro.id, date: Date())))
    }
}

#if DEBUG

    struct ExtendPomodoroView_Previews: PreviewProvider {

        static var previews: some View {
            CountdownExtendView(pomodoro: PreviewData.pomodoro)
        }
    }

#endif
