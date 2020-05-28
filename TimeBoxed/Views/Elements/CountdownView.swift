//
//  CountdownView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct CountdownView: View {
    @State var date = Date()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
    @State var label = "Loading..."

    var body: some View {
        Text(label)
            .onReceive(timer) { input in
                self.label = self.formatter.string(from: Date().timeIntervalSince(self.date))!
            }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(date: Date()).previewLayout(.sizeThatFits)
    }
}
