//
//  CountdownSectionView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct CountdownTimerView: View {
    @EnvironmentObject var store: AppStore
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
                if let project = pomodoro.project {
                    ProjectRowView(project: project).label(left: "Project")
                }
            }.modifier(CenterModifier())
        }
    }
    init(pomodoro: Pomodoro) {
        self._pomodoro = .constant(pomodoro)
    }

    func updateProject(project: Project?) {
        let request = Pomodoro(
            id: pomodoro.id, title: pomodoro.title, start: pomodoro.start, end: pomodoro.end,
            memo: pomodoro.memo, project: project, url: pomodoro.url)
        store.send(.history(.update(request)))
    }
}

#if DEBUG

    struct CountdownSectionView_Previews: PreviewProvider {
        static var previews: some View {
            CountdownTimerView(pomodoro: PreviewData.pomodoro)
        }
    }

#endif
