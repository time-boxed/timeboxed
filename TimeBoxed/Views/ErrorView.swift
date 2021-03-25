//
//  ErrorView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2021/03/21.
//  Copyright © 2021 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    var error: Error
    @EnvironmentObject var store: AppStore

    var body: some View {
        HStack {
            Text(error.localizedDescription)
            Button("X") {
                store.send(.errorClear)
            }
        }
    }
}

//struct ErrorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorView(error: NetworkEr)
//    }
//}
