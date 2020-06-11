//
//  HistoryView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

struct HistoryGroup {
    let date: Date
    let items: [Pomodoro]
}

extension HistoryGroup {
    static func from(_ pomodoros: [Pomodoro]) -> [HistoryGroup] {
        return Dictionary(grouping: pomodoros) { Calendar.current.startOfDay(for: $0.end) }
            .map { HistoryGroup(date: $0, items: $1.sorted { $0.end > $1.end }) }
            .sorted {
                $0.date > $1.date
            }
    }
}

struct HistoryView: View {
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var store = PomodoroStore.shared

    var body: some View {
        NavigationView {
            List {
                ForEach(HistoryGroup.from(store.pomodoros), id: \.date) { gr in
                    Section(header: DateView(date: gr.date)) {
                        ForEach(gr.items) { p in
                            NavigationLink(destination: HistoryDetailView(pomodoro: p)) {
                                HistoryRowView(pomodoro: p)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(userSettings.current_user ?? "Not Logged in")
        }
        .onAppear(perform: store.fetch)
    }
}

#if DEBUG

    struct HistoryView_Previews: PreviewProvider {
        static var previews: some View {
            HistoryView().previewDevice(PreviewData.device)
        }
    }

#endif
