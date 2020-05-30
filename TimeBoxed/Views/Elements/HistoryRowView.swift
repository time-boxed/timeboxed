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
                Text(pomodoro.title)
                    .font(.title)
                Spacer()
                VStack {
                    TimeView(date: pomodoro.start, style: .medium)
                    Spacer()
                    TimeView(date: pomodoro.end, style: .medium)
                    Spacer()
                    IntervalView(elapsed: pomodoro.end.timeIntervalSince(pomodoro.start))
                }.font(.caption)
            }
            Text(pomodoro.category)
                .font(.footnote)
        }
        
    }
}

struct HistoryRowView_Previews: PreviewProvider {
    static var data = Pomodoro(
        id: 0,
        title: "Test Pomodoro",
        start: Date(),
        end: Date(),
        category: "Test Category",
        memo: "Some memo here"
    )
    
    static var previews: some View {
        HistoryRowView(pomodoro: data)
            .previewLayout(.fixed(width: 256, height: 44))
    }
}
