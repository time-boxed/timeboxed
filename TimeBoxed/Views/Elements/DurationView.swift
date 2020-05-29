//
//  DurationView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/29.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct DurationView: View {
    var duration: TimeInterval

    var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }

    var body: some View {
        Text(formatter.string(from: duration)!)
    }
}

struct DurationView_Previews: PreviewProvider {
    static var previews: some View {
        DurationView(duration: TimeInterval(60))
    }
}
