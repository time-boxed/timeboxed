//
//  IntervalView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/30.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct IntervalView: View {
    var elapsed: TimeInterval
    
    var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
    
    var body: some View {
        Text(formatter.string(from: elapsed)!)
    }
}

struct IntervalView_Previews: PreviewProvider {
    static var previews: some View {
        IntervalView(elapsed: TimeInterval(1337))
    }
}
