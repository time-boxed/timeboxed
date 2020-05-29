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
        HStack {
            VStack(alignment: .leading) {
                Text(pomodoro.title)
                    .font(.title)
                Text(pomodoro.category)
                    .font(.caption)
            }

            VStack(alignment: .trailing) {
                DateTimeView(date: pomodoro.start)
                    .font(.caption)
                DateTimeView(date: pomodoro.end)
                    .font(.caption)
            }
        }
    }
}

struct HistoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryRowView(
            pomodoro: Pomodoro(
                id: 0, title: "Test Pomodoro", start: Date(), end: Date(),
                category: "Test Category", memo: ""))
    }
}
