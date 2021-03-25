//
//  HistoryListView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Foundation
import SwiftUI

struct HistoryHeader: View {
    var date: Date
    var pomodoros: [Pomodoro]

    var body: some View {
        NavigationLink(destination: ReportView(date: date, pomodoros: pomodoros)) {
            HStack {
                DateView(date: date)
                Spacer()
                IntervalView(elapsed: pomodoros.map { $0.end.timeIntervalSince($0.start) })
            }
        }
    }
}

struct GroupedHistory: View {
    @EnvironmentObject var store: AppStore
    var groups: [(key: Date, value: [Pomodoro])]

    var body: some View {
        ForEach(groups, id: \.key) { date, pomodoros in
            Section(header: HistoryHeader(date: date, pomodoros: pomodoros)) {
                ForEach(pomodoros) { pomodoro in
                    NavigationLink(destination: HistoryDetailView(pomodoro: pomodoro)) {
                        HistoryRowView(pomodoro: pomodoro)
                    }
                }
                .onDelete(perform: actionDelete)
            }
        }
    }

    init(pomodoros: [Pomodoro]) {
        self.groups = Dictionary(
            grouping: pomodoros,
            by: { Calendar.current.startOfDay(for: $0.end) }
        ).sorted { $0.key > $1.key }
    }

    private func actionDelete(indexSet: IndexSet) {
        store.send(.history(.delete(offset: indexSet)))
    }
}

struct HistoryListView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        NavigationView {
            List {
                GroupedHistory(pomodoros: store.state.pomodoros)
            }
            .onAppear(perform: fetch)
            .listStyle(GroupedListStyle())
            .navigationBarTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reload", action: fetch)
                }
            }
        }
    }

    func fetch() {
        store.send(.history(.fetch))
    }
}

#if DEBUG

    struct HistoryView_Previews: PreviewProvider {
        static var previews: some View {
            HistoryListView().previewDevice(PreviewData.device)
        }
    }

#endif
