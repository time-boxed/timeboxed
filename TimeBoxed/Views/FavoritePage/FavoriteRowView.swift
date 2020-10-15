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
        VStack {
            HStack {
                Text(favorite.title)
                    .font(.title)
                Spacer()
                DurationView(duration: favorite.duration)
            }

            HStack {
                ProjectOptionalView(project: favorite.project)
                Spacer()
                Text("Count: \(favorite.count)")
            }.font(.footnote)

        }

    }
}

#if DEBUG

    struct FavoriteRowView_Previews: PreviewProvider {
        static var previews: some View {
            FavoriteRowView(favorite: PreviewData.favorite)
                .previewLayout(.fixed(width: 256, height: 44))
        }
    }

#endif
