//
//  CountdownCreateView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct CountdownCreateView: View {
    @EnvironmentObject var store: AppStore
    @State var model = Pomodoro(id: 0, title: "", start: Date(), end: Date())

    var body: some View {
        Section(header: Text("New")) {
            TextField("Title", text: $model.title)

            ProjectPicker(project: model.project) { project in
                model.project = project
            }

            Button(action: actionSubmit25) {
                Text("25 Min")
            }
            .buttonStyle(ActionButtonStyle())
            .modifier(CenterModifier())
            .disabled(
                [
                    model.title.count > 0
                ].contains(false))

            Button(action: actionSubmit60) {
                Text("60 Min")
            }
            .buttonStyle(ActionButtonStyle())
            .modifier(CenterModifier())
            .disabled(
                [
                    model.title.count > 0
                ].contains(false))
        }
    }

    func submitPomodoro(duration: TimeInterval) {
        let pomodoro = Pomodoro(
            id: 0, title: model.title, start: Date(), end: Date() + duration,
            memo: "", project: model.project
        )
        store.send(.history(.create(pomodoro)))
        model.title = ""
    }

    func actionSubmit25() {
        submitPomodoro(duration: 25 * 60)
    }

    func actionSubmit60() {
        submitPomodoro(duration: 60 * 60)
    }
}

struct NewPomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownCreateView()
    }
}
