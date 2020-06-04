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

    @State var title: String = ""
    @State var category: String = ""

    var extendPomodoro: some View {
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

    var newPomodoro: some View {
        Section(header: Text("New")) {
            TextField("Title", text: $title)
            TextField("Category", text: $category)
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

    var body: some View {
        List {
            Section() {
                if current != nil {
                    VStack {
                        Text(current!.title)
                            .font(.title)

                        Text(current!.category)

                        CountdownView(date: current!.end)
                            .font(.largeTitle)

                    }.modifier(CenterModifier())
                }
            }

            if current?.isActive ?? false {
                extendPomodoro
            } else {
                newPomodoro
            }

        }.onAppear(perform: store.fetch)
            .listStyle(GroupedListStyle())
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
