//
//  NewFavoriteView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/13.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct AddFavoriteButton: View {
    @State var isPresenting = false

    var body: some View {
        Button("Add") {
            isPresenting.toggle()
        }.sheet(isPresented: $isPresenting) {
            SheetNewFavoriteView(isPresented: self.$isPresenting)
                .sheetWithDone(isPresented: self.$isPresenting)
        }
    }
}

struct SheetNewFavoriteView: View {
    @EnvironmentObject var store: FavoriteStore

    @Binding var isPresented: Bool

    @State var newFavorite = Favorite(
        id: 0,
        title: "",
        duration: 25,
        memo: "",
        icon: nil,
        html_link: URL(string: "https://example.com")!,
        url: nil,
        count: 0
    )

    var body: some View {
        List {
            TextField("Title", text: $newFavorite.title)
            Slider(value: $newFavorite.duration, in: 0...60, step: 1)
            Text("Duration: \(newFavorite.duration.rounded())")
            Button(action: submit) {
                Text("Submit")
            }.buttonStyle(ActionButtonStyle())
        }
        .navigationBarTitle(Text("New Favorite"), displayMode: .inline)
    }

    func submit() {
        store.create(newFavorite) { (favorite) in
            self.isPresented = false
        }
    }
}

struct NewFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        SheetNewFavoriteView(isPresented: .constant(true))
    }
}
