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

struct HistoryView: View {
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var store = PomodoroStore.shared

    var groups: [Date: [Pomodoro]] {
        Dictionary(
            grouping: store.pomodoros,
            by: { Calendar.current.startOfDay(for: $0.end) }
        )
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(groups.keys.sorted { $0 > $1 }, id: \.self) { date in
                    Section(header: DateView(date: date)) {
                        ForEach(self.groups[date]!.sorted { $0.end > $1.end }, id: \.id) { p in
                            NavigationLink(destination: HistoryDetailView(pomodoro: p)) {
                                HistoryRowView(pomodoro: p)
                                    .onAppear {
                                        if self.store.pomodoros.last == p {
                                            self.store.fetch()
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("History")
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
