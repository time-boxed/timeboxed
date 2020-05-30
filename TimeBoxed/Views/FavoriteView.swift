//
//  FavoriteView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct FavoriteView: View {
    @ObservedObject var store = FavoriteStore()

    var body: some View {
        List(store.favorites) { item in
            FavoriteRowView(favorite: item)
        }
        .onAppear(perform: store.fetch)
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView().previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
