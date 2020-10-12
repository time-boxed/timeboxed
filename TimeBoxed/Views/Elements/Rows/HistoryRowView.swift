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
            Text(pomodoro.title)
                .font(.title)
            HStack(alignment: .top) {
                TimeView(date: pomodoro.start, style: .medium)
                Spacer()
                TimeView(date: pomodoro.end, style: .medium)
            }
            HStack(alignment: .top) {
                ProjectOptionalView(project: pomodoro.project)
                Spacer()
                IntervalView(from: pomodoro.start, to: pomodoro.end)
            }.font(.footnote)
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
