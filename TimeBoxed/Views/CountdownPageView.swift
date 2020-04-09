//
//  CountdownView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct CountdownPageView: View {
    var body: some View {
        VStack {
            Text("Title")
            Text("Category")
            Text("Countdown")
        }
    }
}

struct CountdownPageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountdownPageView()
        }.previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
