//
//  TimeView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/30.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct TimeView:View {
    var date: Date
    var style = DateFormatter.Style.medium

    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = style
        return formatter
    }

    var body: some View {
        Text(formatter.string(from: date))
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView(date: Date())
    }
}
