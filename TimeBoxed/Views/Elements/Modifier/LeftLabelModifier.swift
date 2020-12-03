//
//  LeftLabelModifier.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/11.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

fileprivate struct LeftLabelModifier: ViewModifier {
    var label: String
    func body(content: Content) -> some View {
        HStack {
            Text(label)
            Spacer()
            content
        }
    }
}

extension View {
    func label(left: String) -> some View {
        return self.modifier(LeftLabelModifier(label: left))
    }
}
