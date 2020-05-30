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
    @State private var currentUser = Settings.defaults.string(forKey: .currentUser)
    @State private var viewModel: Pomodoro?
    @State private var cancellable: AnyCancellable?

    func loadData() {
        guard currentUser != nil else { return }
        cancellable = Pomodoro.list()
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .map { $0.first }
            .assign(to: \.viewModel, on: self)
    }

    @ViewBuilder
    var body: some View {
        VStack {
            if viewModel != nil {
                Text(viewModel!.title)
                    .font(.title)
                Text(viewModel!.category)
                CountdownView(date: viewModel!.end)
                    .font(.largeTitle)

            }
            Divider()

            Button(action: actionAddPomodoro) {
                Text("25 Min")
            }
            .buttonStyle(ActionButtonStyle())

            Button(action: actionAddHour) {
                Text("60 Min")
            }
            .buttonStyle(ActionButtonStyle())
        }.onAppear(perform: loadData)
    }
    
    func actionAddPomodoro() {
        
    }
    
    func actionAddHour() {
        
    }
}

struct CountdownPageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountdownPageView()
        }.previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
