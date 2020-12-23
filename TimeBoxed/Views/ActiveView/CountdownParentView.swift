//
//  ActiveCountdownView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct CountdownParentView: View {
    @EnvironmentObject var store: PomodoroStore

    var body: some View {
        NavigationView {
            List {
                if let current = store.pomodoros.first {
                    NavigationLink(destination: HistoryEditViewOld(pomodoro: current)) {
                        CountdownTimerView(pomodoro: current)
                    }

                    if current.isActive {
                        CountdownExtendView(pomodoro: current)
                    } else {
                        CountdownCreateView()
                    }
                }
                AsyncContentView(source: store) { _ in
                    EmptyView()
                }
            }
            .listStyle(GroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ReloadButton(source: store)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
#if DEBUG

    struct CountdownPageView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                CountdownParentView()
            }.previewDevice(PreviewData.device)
        }
    }

#endif
