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
    var style = DateFormatter.Style.medium

    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = style
        formatter.dateStyle = style
        return formatter
    }

    var body: some View {
        Text(formatter.string(from: date))
    }
}

struct DateTimeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DateTimeView(date: Date(), style: .short)
                .previewLayout(.sizeThatFits)
            DateTimeView(date: Date(), style: .medium)
                .previewLayout(.sizeThatFits)
            DateTimeView(date: Date(), style: .long)
                .previewLayout(.sizeThatFits)
        }
    }
}
