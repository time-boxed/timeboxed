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
        }
    }

    func actionAddPomodoro() {

    }

    func actionAddHour() {

    }
}

#if DEBUG

    struct ExtendPomodoroView_Previews: PreviewProvider {

        static var previews: some View {
            ExtendPomodoroView(pomodoro: PreviewData.pomodoro)
        }
    }

#endif
