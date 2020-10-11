//
//  LabelModifier.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/11.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct LabelModifier: ViewModifier {
    var label: String
    func body(content: Content) -> some View {
        HStack {
            Text(label)
            Spacer()
            content
        }
    }
}
