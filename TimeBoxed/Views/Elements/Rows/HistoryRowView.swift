//
//  HistoryRowView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/29.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct HistoryRowView: View {
    var pomodoro: Pomodoro

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(pomodoro.title)
                        .font(.title)
                    if let project = pomodoro.project {
                        Text(project.name)
                            .foregroundColor(project.color)
                    }
                }
                Spacer()
                VStack {
                    TimeView(date: pomodoro.start, style: .medium)
                    Spacer()
                    TimeView(date: pomodoro.end, style: .medium)
                    Spacer()
                    IntervalView(elapsed: pomodoro.end.timeIntervalSince(pomodoro.start))
                }.font(.caption)
            }
        }

    }
}

#if DEBUG

    struct HistoryRowView_Previews: PreviewProvider {
        static var previews: some View {
            HistoryRowView(pomodoro: PreviewData.pomodoro)
                .previewLayout(.fixed(width: 256, height: 44))
        }
    }

#endif
