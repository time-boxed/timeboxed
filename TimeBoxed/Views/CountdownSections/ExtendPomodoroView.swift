//
//  ExtendPomodoroView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ExtendPomodoroView: View {
    var pomodoro: Pomodoro

    var body: some View {
        Section(header: Text("Extend")) {
            Button(action: actionAddPomodoro) {
                Text("25 Min")
            }
            .buttonStyle(ActionButtonStyle())
            .modifier(CenterModifier())

            Button(action: actionAddHour) {
                Text("60 Min")
            }
            .buttonStyle(ActionButtonStyle())
            .modifier(CenterModifier())

            Button(action: actionStop) {
                Text("Stop")
            }
            .buttonStyle(DangerButtonStyle())
            .modifier(CenterModifier())
        }
    }

    func updatePomodoro(date: Date) {
        var request = URLRequest.request(path: "/api/pomodoro/\(pomodoro.id)")
        request.httpMethod = "PATCH"

        let update = Pomodoro.DateRequest(end: Date())
        print(request.debugDescription)
        print(update)
    }

    func actionAddPomodoro() {
        updatePomodoro(date: pomodoro.end + TimeInterval(25 * 60))
    }

    func actionAddHour() {
        updatePomodoro(date: pomodoro.end + TimeInterval(60 * 60))
    }

    func actionStop() {
        updatePomodoro(date: Date())
    }
}

#if DEBUG

    struct ExtendPomodoroView_Previews: PreviewProvider {

        static var previews: some View {
            ExtendPomodoroView(pomodoro: PreviewData.pomodoro)
        }
    }

#endif
