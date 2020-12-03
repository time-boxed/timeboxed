//
//  CountdownExtendView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct CountdownExtendView: View {
    @EnvironmentObject var store: PomodoroStore
    @Binding var pomodoro: Pomodoro

    init(pomodoro: Pomodoro) {
        self._pomodoro = .constant(pomodoro)
    }

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

    private func onReceive(_ batch: Pomodoro) {
        print(pomodoro)
        store.load()
    }

    func actionAddPomodoro() {
        store.update(
            id: pomodoro.id, end: pomodoro.end.addingTimeInterval(25 * 60), completion: onReceive)
    }

    func actionAddHour() {
        store.update(
            id: pomodoro.id, end: pomodoro.end.addingTimeInterval(60 * 60), completion: onReceive)
    }

    func actionStop() {
        store.update(id: pomodoro.id, end: Date(), completion: onReceive)
    }
}

#if DEBUG

    struct ExtendPomodoroView_Previews: PreviewProvider {

        static var previews: some View {
            CountdownExtendView(pomodoro: PreviewData.pomodoro)
        }
    }

#endif
