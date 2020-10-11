//
//  FavoriteRowView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/29.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import KingfisherSwiftUI
import SwiftUI

struct FavoriteRowView: View {
    var favorite: Favorite

    var body: some View {
        HStack {
            Group {
                if favorite.icon != nil {
                    KFImage(favorite.icon!)
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                }
            }

            VStack(alignment: .leading) {
                Text(favorite.title)
                    .font(.title)
                if let project = favorite.project {
                    ProjectRowView(project: project)
                }
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

#if DEBUG

    struct FavoriteRowView_Previews: PreviewProvider {
        static var previews: some View {
            FavoriteRowView(favorite: PreviewData.favorite)
                .previewLayout(.fixed(width: 256, height: 44))
        }
    }

#endif
