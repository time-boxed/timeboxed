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
    var date: Date

    var body: some View {
        TimelineView(PeriodicTimelineSchedule(from: Date(), by: 1)) { context in
            ColorInterval(elapsed: context.date.timeIntervalSince(date))
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(date: Date()).previewLayout(.sizeThatFits)
    }
}


struct ColorInterval: View {
    var elapsed: TimeInterval
    var color: Color  {
        switch elapsed {
        case _ where elapsed < 0:
            return.green
        case _ where elapsed > 600:
            return .red
        default:
            return .blue
        }
    }
    var body: some View {
        IntervalView(elapsed: elapsed)
            .foregroundColor(color)
    }
}
