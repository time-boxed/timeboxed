//
//  HistoryView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct HistoryView: View {
    @State private var viewModel = [Pomodoro]()
    @State private var cancellable: AnyCancellable?

    func loadData() {
        cancellable = Pomodoro.list()
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.viewModel, on: self)
    }

    var body: some View {
        List(viewModel) { item in
            HistoryRowView(pomodoro: item)
        }
        .onAppear(perform: loadData)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
