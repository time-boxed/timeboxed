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
    @EnvironmentObject var store: PomodoroStore

    var body: some View {
        NavigationView {
            List {
                AsyncContentView(source: store) { pomodoros in
                    if let current = pomodoros.first {
                        CountdownSectionView(pomodoro: current)

                        if current.isActive {
                            ExtendPomodoroView(pomodoro: current)
                        } else {
                            NewPomodoroView()
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarItems(
                trailing: ReloadButton(source: store)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
