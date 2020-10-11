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

extension Array where Element == Pomodoro {
    func byEndDate() -> [Date: [Pomodoro]] {
        return Dictionary(
            grouping: self,
            by: { Calendar.current.startOfDay(for: $0.end) }
        )
    }
}

struct HistoryView: View {
    @EnvironmentObject var store: PomodoroStore

    var groups: [Date: [Pomodoro]] {
        Dictionary(
            grouping: store.pomodoros,
            by: { Calendar.current.startOfDay(for: $0.end) }
        )
    }

    var fetchedView: some View {
        ForEach(groups.keys.sorted { $0 > $1 }, id: \.self) { date in
            Section(header: DateView(date: date)) {
                ForEach(self.groups[date]!.sorted { $0.end > $1.end }) { p in
                    NavigationLink(destination: HistoryDetailView(pomodoro: p)) {
                        HistoryRowView(pomodoro: p)
                            .onAppear {
                                if self.store.pomodoros.last == p {
                                    self.store.fetch()
                                }
                            }
                    }
                }.onDelete(perform: self.store.delete)
            }
        }
    }

    var stateStatus: AnyView {
        switch store.state {
        case .empty:
            return Text("No result").eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .fetching:
            return Text("Loading").eraseToAnyView()
        case .fetched:
            return EmptyView().eraseToAnyView()
        }
    }

    var body: some View {
        NavigationView {
            List {
                HStack {
                    Button("Reload", action: store.fetch)
                    Spacer()
                    stateStatus
                }
                fetchedView
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("History")
            .navigationBarItems(leading: EditButton())
        }
        .onAppear(perform: store.reload)
    }
}

#if DEBUG

    struct HistoryView_Previews: PreviewProvider {
        static var previews: some View {
            HistoryView().previewDevice(PreviewData.device)
        }
    }

#endif
