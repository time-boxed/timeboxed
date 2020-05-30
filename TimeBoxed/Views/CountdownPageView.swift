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

            } else {
                Text("Loading").onAppear(perform: self.loadData)
            }
            Divider()

            Button(action: {}) {
                Text("25 Min")
            }
            .buttonStyle(ActionButtonStyle())

            Button(action: {}) {
                Text("60 Min")
            }
            .buttonStyle(ActionButtonStyle())
        }
    }
}

struct CountdownPageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountdownPageView()
        }.previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
