//
//  HistoryEditView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/12/23.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct HistoryEditView: View {
    @Binding var history: Pomodoro.Data

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $history.title)
                HStack {
                    DateTimeView(date: history.start)
                    Spacer()
                    DateTimeView(date: history.end)
                }
                ProjectPicker(project: history.project) { project in
                    history.project = project
                }
            }
            Section(header: Text("Memo")) {
                TextEditor(text: $history.memo)
            }
        }
    }
}

struct HistoryEditView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryEditView(history: .constant(PreviewData.pomodoro.data))
    }
}

extension Pomodoro {
    struct Data: Encodable {
        var title = ""
        var start = Date()
        var end = Date()
        var project: Project?
        var url: URL?
        var memo = ""
    }

    var data: Data {
        return Data(title: title, start: start, end: end, project: project, url: url, memo: memo)
    }

    mutating func update(from data: Data) {
        title = data.title
        project = data.project
        url = data.url
        memo = data.memo
        start = data.start
        end = data.end
    }
}
