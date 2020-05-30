//
//  DateView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/30.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct DateView: View {
    var date: Date
    var style = DateFormatter.Style.medium

    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter
    }

    var body: some View {
        Text(formatter.string(from: date))
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView(date: Date())
    }
}
