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
    @State private var viewModel = [Favorite]()
    @State private var cancellable: AnyCancellable?
    
    func loadData() {
        cancellable = Favorite.list()
            .receive(on: DispatchQueue.main)
            .print()
            .replaceError(with: [])
            .assign(to: \.viewModel, on: self)
    }
    
    var body: some View {
        List(viewModel) { item in
            FavoriteRowView(favorite: item)
        }
        .onAppear(perform: loadData)
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView().previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
