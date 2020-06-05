//
//  CountdownSectionView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct CountdownSectionView: View {
    var pomodoro: Pomodoro

    var body: some View {
        Section {
            VStack {
                Text(pomodoro.title)
                    .font(.title)

                Text(pomodoro.category)

                CountdownView(date: pomodoro.end)
                    .font(.largeTitle)

            }.modifier(CenterModifier())
        }
    }
}

struct CountdownSectionView_Previews: PreviewProvider {
    static var data = Pomodoro(
        id: 0,
        title: "Test Title",
        start: Date(),
        end: Date(),
        category: "Test Category",
        memo: ""
    )
    static var previews: some View {
        CountdownSectionView(pomodoro: data)
    }
}
