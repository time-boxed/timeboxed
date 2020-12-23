//
//  FavoriteEditView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/12/23.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct FavoriteEditView: View {
    @Binding var favorite: Favorite.Data
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $favorite.title)
                Slider(value: $favorite.duration, in: 5...60, step: 1.0) {
                    Label("Duration", systemImage: "clock")
                }
                Text("\(Int(favorite.duration)) minutes")
                ProjectSelectorView(project: favorite.project) { project in
                    favorite.project = project
                }
            }
            Section(header: Text("Memo")) {
                TextEditor(text: $favorite.memo)
            }
        }
    }
}

struct FavoriteEditPage_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteEditView(favorite: .constant(PreviewData.favorite.data))
            .previewLayout(.sizeThatFits)
    }
}

extension Favorite {
    struct Data: Encodable {
        var title: String = ""
        var duration: TimeInterval = 0
        var project: Project?
        var url: URL?
        var memo = ""
    }

    var data: Data {
        return Data(title: title, duration: duration, project: project, url: url, memo: memo ?? "")
    }

    mutating func update(from data: Data) {
        title = data.title
        project = data.project
        url = data.url
        memo = data.memo
        duration = data.duration
    }
}
