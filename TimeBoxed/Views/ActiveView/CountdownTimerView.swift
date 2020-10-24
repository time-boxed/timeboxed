//
//  CountdownSectionView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct CountdownTimerView: View {
    @Binding var pomodoro: Pomodoro
    var body: some View {
        Section {
            VStack {
                Text(pomodoro.title)
                    .font(.system(size: 32))

                CountdownView(date: pomodoro.end)
                    .font(.system(size: 72))

                DateTimeView(label: "Start", date: pomodoro.start)
                DateTimeView(label: "End", date: pomodoro.end)

                ProjectSelectorView(project: pomodoro.project) { newProject in
                    pomodoro.project = newProject
                }
            }.modifier(CenterModifier())
        }
    }
    init(pomodoro: Pomodoro) {
        self._pomodoro = .constant(pomodoro)
    }
}

#if DEBUG

    struct CountdownSectionView_Previews: PreviewProvider {
        static var previews: some View {
            CountdownTimerView(pomodoro: PreviewData.pomodoro)
        }
    }

#endif
