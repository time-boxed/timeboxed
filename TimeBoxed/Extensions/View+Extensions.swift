//
//  View+Extensions.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/13.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

extension View {
    func sheetWithDone(isPresented: Binding<Bool>) -> some View {
        NavigationView {
            self
                .navigationBarItems(
                    trailing: Button(action: {
                        isPresented.wrappedValue = false
                    }) {
                        Text("Done").bold()
                    })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


extension Text {
    init (optional: String?) {
        self.init(verbatim: optional ?? "")
    }
}
