//
//  HistoryDetailView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/30.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct HistoryDetailView: View {
    var pomodoro: Pomodoro

    var body: some View {
        List {
            ProjectSelectorView(project: pomodoro.project)
            HStack {
                DateTimeView(date: pomodoro.start)
                Spacer()
                DateTimeView(date: pomodoro.end)
            }
            if let url = pomodoro.url {
                Link("Open", destination: url)
            }
            Text(optional: pomodoro.memo)
            Section {
                Button(action: actionDelete) {
                    Text("Repeat")
                }
                .buttonStyle(ActionButtonStyle())
                .modifier(CenterModifier())

                Button(action: actionDelete) {
                    Text("Delete")
                }
                .buttonStyle(DangerButtonStyle())
                .modifier(CenterModifier())
            }
        }
        .navigationBarTitle(pomodoro.title)
        .listStyle(GroupedListStyle())
    }

    func actionDelete() {

    }
}

#if DEBUG

    struct HistoryDetailView_Previews: PreviewProvider {
        static var previews: some View {
            HistoryDetailView(pomodoro: PreviewData.pomodoro)
        }
    }

#endif
