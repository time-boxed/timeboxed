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
            Text(pomodoro.title)
                .font(.largeTitle)
            Text(pomodoro.category)
            HStack {
                DateTimeView(date: pomodoro.start)
                DateTimeView(date: pomodoro.end)
            }
            if pomodoro.url != nil {
                OpenLinkView(url: pomodoro.url!)
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
        }.navigationBarTitle(pomodoro.title)
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
