//
//  ProjectEditView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/12/23.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ProjectEditView: View {
    @Binding var project: Project.Data

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $project.name)
                ColorPicker("Color", selection: $project.color)
                Toggle("Active", isOn: $project.active)
            }
            Section(header: Text("Memo")) {
                TextEditor(text: $project.memo)
            }
        }
    }
}

struct ProjectEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectEditView(project: .constant(PreviewData.project.data))
            .previewLayout(.sizeThatFits)
    }
}

extension Project {
    struct Data: Codable {
        var name: String = ""
        var color: Color = .pink
        var active = true
        var memo = ""
    }

    var data: Data {
        return Data(name: name, color: color, active: active, memo: memo)
    }

    mutating func update(from data: Data) {
        name = data.name
        color = data.color
        active = data.active
        memo = data.memo
    }
}
