//
//  NameValueView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/04.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct NameValueView: View {
    var name: String
    var value: String

    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text(value)
        }
    }
}

struct NameValueView_Previews: PreviewProvider {
    static var previews: some View {
        NameValueView(name: "Some Name", value: "Some Value")
    }
}
