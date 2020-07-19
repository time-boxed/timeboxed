//
//  CenterModifier.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/04.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}
