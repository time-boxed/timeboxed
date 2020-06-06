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
    @ObservedObject var store = PomodoroStore()
    private var current: Pomodoro? {
        return store.pomodoros.first
    }

    var body: some View {
        List {
            if current != nil {
                CountdownSectionView(pomodoro: current!)
            }

            if current?.isActive ?? false {
                ExtendPomodoroView(pomodoro: current!)
            } else {
                NewPomodoroView()
            }

        }.onAppear(perform: store.fetch)
            .listStyle(GroupedListStyle())
    }
}

struct CountdownPageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountdownPageView()
        }.previewDevice(PreviewData.device)
    }
}
