//
//  CountdownView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct CountdownPageView: View {
    @ObservedObject var store = PomodoroStore.shared

    var body: some View {
        List {
            if store.currentPomodoro != nil {
                CountdownSectionView(pomodoro: .constant(store.currentPomodoro!))
            }

            if store.currentPomodoro?.isActive ?? false {
                ExtendPomodoroView(pomodoro: store.currentPomodoro!)
            } else {
                NewPomodoroView()
            }
        }.onAppear(perform: store.fetch)
            .listStyle(GroupedListStyle())
    }

}

#if DEBUG

    struct CountdownPageView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                CountdownPageView()
            }.previewDevice(PreviewData.device)
        }
    }

#endif
