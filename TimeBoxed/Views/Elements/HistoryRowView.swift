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
                    .font(.footnote)
            }
            Spacer()
            VStack(alignment: .trailing) {
                DateTimeView(date: pomodoro.start, style: .short)
                    .font(.caption)
                Spacer()
                DateTimeView(date: pomodoro.end, style: .short)
                    .font(.caption)
            }
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
