//
//  ImageButton.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ImageButton: View {
    var systemName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
        }
    }
}

struct ImageButton_Previews: PreviewProvider {
    static var previews: some View {
        ImageButton(systemName: "test", action: { print("Clicked") })
    }
}
