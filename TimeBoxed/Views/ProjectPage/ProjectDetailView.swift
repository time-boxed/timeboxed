//
//  ProjectDetailView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/11.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ProjectDetailView: View {
    @State var project: Project
    @EnvironmentObject var store: ProjectStore

    var body: some View {
        List {
            Section {
                TextField("Name", text: $project.name)
                if let url = project.url {
                    Link("URL", destination: url)
                }
                ColorPicker("Color", selection: $project.color)
                Toggle("Active", isOn: $project.active)
            }
            Section(header: Text("Memo")) {
                TextEditor(text: $project.memo)
                    .frame(height: 128)
            }
            Section {
                Button("Save", action: actionSave).disabled(
                    [
                        project.name.count > 1
                    ].contains(false))
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(project.name)
    }

    func actionSave() {
        store.update(project: project) { updatedProject in
            print(updatedProject)
            store.load()
        }
    }
}

//struct ProjectDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectDetailView()
//    }
//}
