//
//  DateTimeView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/29.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct DateTimeView: View {
    var date: Date

    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return formatter
    }

    var body: some View {
        Text(formatter.string(from: date))
    }
}

struct DateTimeView_Previews: PreviewProvider {
    static var previews: some View {
        DateTimeView(date: Date())
    }
}
