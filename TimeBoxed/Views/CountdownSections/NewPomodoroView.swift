//
//  NewPomodoroView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct NewPomodoroView: View {
    @State var title: String = ""
    @State var category: String = ""

    var body: some View {
        Section(header: Text("New")) {
            TextField("Title", text: $title)
            TextField("Category", text: $category)
            Button(action: actionSubmit25) {
                Text("25 Min")
            }
            .buttonStyle(ActionButtonStyle())
            .modifier(CenterModifier())

            Button(action: actionSubmit60) {
                Text("60 Min")
            }
            .buttonStyle(ActionButtonStyle())
            .modifier(CenterModifier())
        }
    }

    func submitPomodoro(duration: TimeInterval) {
        let pomodoro = Pomodoro(
            id: 0, title: title, start: Date(), end: Date() + duration, category: category, memo: ""
        )
        print(pomodoro)
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
        NewPomodoroView()
    }
}
