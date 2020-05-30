//
//  FavoriteRowView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/29.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct FavoriteRowView: View {
    @Environment(\.imageCache) var cache: ImageCache
    
    var favorite: Favorite
    
    var body: some View {
        HStack {
            Group {
                if favorite.icon != nil {
                    AsyncImage(
                        url: favorite.icon!,
                        cache: self.cache,
                        placeholder: Text("Loading ..."),
                        configuration: { $0.resizable() }
                    )
                        .frame(width: 32.0, height: 32.0)
                }
            }
            
            VStack(alignment: .leading) {
                Text(favorite.title)
                    .font(.title)
                Text(favorite.memo ?? "")
                    .font(.footnote)
            }
            Spacer()
            VStack {
                DurationView(duration: favorite.duration)
                Text("Count: \(favorite.count)")
                Text(favorite.memo ?? "")
                
            }.font(.caption)
        }
        
    }
}

struct FavoriteRowView_Previews: PreviewProvider {
    static var data = Favorite(
        id: 0,
        title: "Test",
        duration: 30,
        memo: "",
        icon: nil,
        html_link: URL(string: "https://example.com")!,
        url: URL(string: "https://example.com"),
        count: 1
    )
    static var previews: some View {
        FavoriteRowView(favorite: data)
            .previewLayout(.fixed(width: 256, height: 44))
    }
}
