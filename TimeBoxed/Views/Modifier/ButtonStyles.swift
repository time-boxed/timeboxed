//
//  ButtonStyles.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/29.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 128, minHeight: 44)
            .padding(.horizontal)
            .foregroundColor(Color.accentColor)
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor))
    }
}
