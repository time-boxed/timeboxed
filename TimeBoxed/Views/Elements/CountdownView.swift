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

    @State private var color = Color.white
    @State private var elapsed = TimeInterval()
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private func tick(tick: Date) {
        elapsed = Date().timeIntervalSince(date)
        
        switch elapsed {
        case _ where elapsed < 0:
            color = .green
        case _ where elapsed > 600:
            color = .red
        default:
            color = .blue
        }
    }
    
    var body: some View {
        IntervalView(elapsed: elapsed)
            .foregroundColor(color)
            .onReceive(timer, perform: tick)
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(date: Date()).previewLayout(.sizeThatFits)
    }
}
