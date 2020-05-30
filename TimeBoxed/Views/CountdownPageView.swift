//
//  CountdownView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct CountdownPageView: View {
    @ObservedObject var store = PomodoroStore()
    private var current: Pomodoro? {
        return store.pomodoros.first
    }

    @ViewBuilder
    var body: some View {
        VStack {
            if current != nil {
                Text(current!.title)
                    .font(.title)
                Text(current!.category)
                CountdownView(date: current!.end)
                    .font(.largeTitle)
            }
            Divider()

            Button(action: actionAddPomodoro) {
                Text("25 Min")
            }
            .buttonStyle(ActionButtonStyle())

            Button(action: actionAddHour) {
                Text("60 Min")
            }
            .buttonStyle(ActionButtonStyle())
        }.onAppear(perform: store.fetch)
    }

    func actionAddPomodoro() {

    }

    func actionAddHour() {

    }
}

struct CountdownPageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountdownPageView()
        }.previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
