//
//  ProjectCreateSheet.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/12.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct AddProjectButton: View {
    @State var isPresenting = false

    var body: some View {
        Button("Add") {
            isPresenting.toggle()
        }.sheet(isPresented: $isPresenting) {
            ProjectCreateSheet()
        }
    }
}

struct ProjectCreateSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: ProjectStore

    @State var project = Project(
        id: "",
        name: "",
        html_link: URL(string: "http://example.com")!,
        url: nil,
        color: .black,
        active: true,
        memo: "",
        duration: 0
    )

    var body: some View {
        List {
            TextField("Title", text: $project.name)
            ColorPicker("Color", selection: $project.color)
            Button("Submit", action: submitCreate)
                .buttonStyle(ActionButtonStyle())
                .disabled(
                    [
                        project.name.count > 0
                    ].contains(false))
        }
    }

    func submitCreate() {
        store.create(
            project
        ) { newProject in
            store.load()
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ProjectCreateView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectCreateSheet()
    }
}
