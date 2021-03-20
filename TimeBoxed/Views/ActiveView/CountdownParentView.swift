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
    @EnvironmentObject var store: AppStore

    var body: some View {
        NavigationView {
            List {
                if let current = store.state.pomodoros.first {
                    CountdownTimerView(pomodoro: current)
                    //                    NavigationLink(destination: HistoryEditView(history: .constant(current.data))) {
                    //                        CountdownTimerView(pomodoro: current)
                    //                    }
                    if current.isActive {
                        CountdownExtendView(pomodoro: current)
                    } else {
                        CountdownCreateView()
                    }
                } else {
                    Text("Loading...").onAppear(perform: fetch)
                }
            }
            .listStyle(GroupedListStyle())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func fetch() {
        store.send(.historyFetch)
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
