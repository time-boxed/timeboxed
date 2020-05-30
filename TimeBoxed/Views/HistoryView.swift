//
//  HistoryView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct HistoryView: View {
    @ObservedObject var store = PomodoroStore()

    var body: some View {
        List(store.pomodoros) { item in
            Section(header: Text("Examples")) {
                HistoryRowView(pomodoro: item)
            }
        }
        .onAppear(perform: store.fetch)
        .listStyle(GroupedListStyle())
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
