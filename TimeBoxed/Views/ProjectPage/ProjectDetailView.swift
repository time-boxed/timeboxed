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
    @State private var isPresented = false
    @State private var data = Project.Data()

    var body: some View {
        Group {
            List {
                Section {
                    Text(project.name)
                    if let url = project.url {
                        Link("URL", destination: url)
                    }
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(project.color)
                        .label(left: "Color")
                }

                Section(header: Text("Memo")) {
                    Text(project.memo)
                }

                Section(header: Text("Quickstart")) {
                    Button("Quickstart", action: actionQuickstart)
                        .buttonStyle(ActionButtonStyle())
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle(project.name)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit", action: actionShowEdit)
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationView {
                ProjectEditView(project: $data)
                    .navigationTitle(project.name)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel", action: actionCancelEdit)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done", action: actionSaveEdit)
                        }
                    }
            }
        }
    }

    private func actionShowEdit() {
        isPresented = true
        data = project.data
    }

    private func actionCancelEdit() {
        isPresented = false
    }

    private func actionSaveEdit() {
        // Update our local copy for visual purposes
        project.update(from: data)
        // Then update the server version
        store.update(project: project) { updatedProject in
            isPresented = false
            store.load()
        }
    }

    private func actionQuickstart() {

    }
}
#if DEBUG
    struct ProjectDetailView_Previews: PreviewProvider {
        static var previews: some View {
            ProjectDetailView(project: PreviewData.project)
                .previewLayout(.sizeThatFits)
        }
    }
#endif
