//
//  HistoryView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

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

    var body: some View {
        NavigationView {
            List {
                AsyncContentView(source: store) { pomodoros in
                    let groups = pomodoros.byEndDate()
                    ForEach(groups.keys.sorted { $0 > $1 }, id: \.self) { date in
                        Section(header: DateView(date: date)) {
                            ForEach(groups[date]!.sorted { $0.end > $1.end }) { pomodoro in
                                NavigationLink(destination: HistoryDetailView(pomodoro: pomodoro)) {
                                    HistoryRowView(pomodoro: pomodoro)
                                }
                            }
                        }
                    }
                }
                ReloadButton(source: store)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("History")
            .navigationBarItems(leading: EditButton())
        }
    }
}

#if DEBUG

    struct HistoryView_Previews: PreviewProvider {
        static var previews: some View {
            HistoryView().previewDevice(PreviewData.device)
        }
    }

#endif
