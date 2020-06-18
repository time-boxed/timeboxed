//
//  ValidationModifier.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/18.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ValidationModifier: ViewModifier {
    @State var latestValidation: Validation = .success
    let validationPublisher: ValidationPublisher

    func body(content: Content) -> some View {
        return VStack(alignment: .leading) {
            content
            validationMessage
        }.onReceive(validationPublisher) { validation in
            self.latestValidation = validation
        }
    }

    @ViewBuilder
    var validationMessage: some View {
        switch latestValidation {
        case .success:
            return EmptyView()
        case .failure(let message):
            return Text(message)
                .foregroundColor(Color.red)
                .font(.caption)
        }
    }
}

extension View {
    func validation(_ validationPublisher: ValidationPublisher) -> some View {
        self.modifier(ValidationModifier(validationPublisher: validationPublisher))
    }
}
