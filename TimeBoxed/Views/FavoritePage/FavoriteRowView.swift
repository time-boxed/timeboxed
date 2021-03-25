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
    var showProject = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(favorite.title)
                .font(.title)

            if showProject {
                ProjectOptionalView(project: favorite.project)
            }

            HStack {
                DurationView(duration: favorite.duration)
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
