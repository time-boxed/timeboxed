//
//  FavoriteRowView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/29.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct FavoriteRowView: View {
    var favorite: Favorite

    var body: some View {
        HStack {
            Text(favorite.title)
                .font(.title)
            VStack {
                DurationView(duration: favorite.duration)
                Text("Count: \(favorite.count)")
                Text(favorite.memo ?? "")

            }.font(.caption)
        }

    }
}

struct FavoriteRowView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteRowView(
            favorite: Favorite(
                id: 0, title: "Test", duration: 30, memo: "", icon: nil,
                html_link: URL(string: "https://example.com")!,
                url: URL(string: "https://example.com"), count: 1))
    }
}
