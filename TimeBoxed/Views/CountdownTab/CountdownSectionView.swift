//
//  CountdownSectionView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct CountdownSectionView: View {
    @Binding var pomodoro: Pomodoro

    var body: some View {
        Section {
            VStack {
                Text(pomodoro.title)
                    .font(.title)

                Text(pomodoro.category)

                CountdownView(date: .constant(pomodoro.end))
                    .font(.largeTitle)

            }.modifier(CenterModifier())
        }
    }
}

#if DEBUG

    struct CountdownSectionView_Previews: PreviewProvider {
        static var previews: some View {
            CountdownSectionView(pomodoro: .constant(PreviewData.pomodoro))
        }
    }

#endif
