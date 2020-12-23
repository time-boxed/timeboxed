//
//  ProjectListView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ProjectListView: View {
    @EnvironmentObject var store: ProjectStore

    @State private var isPresented = false
    @State private var data = Project.Data()

    var body: some View {
        NavigationView {
            List {
                AsyncContentView(source: store) { projects in
                    ForEach(projects.sorted { $0.duration > $1.duration }) { project in
                        NavigationLink(destination: ProjectDetailView(project: project)) {
                            VStack(alignment: .leading) {
                                ProjectRowView(project: project)
                                    .font(.title)
                                DurationView(duration: project.duration)
                                    .font(.footnote)
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        indexSet.forEach { index in
                            store.delete(project: projects[index]) { _ in
                                store.load()
                            }
                        }
                    })
                }

            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add", action: actionShowAdd)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    ReloadButton(source: store)
                }
            }
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    ProjectEditView(project: $data)
                        .navigationTitle("Add Project")
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
    }

    private func actionShowAdd() {
        isPresented = true
        data = .init()
    }

    private func actionCancelEdit() {
        isPresented = false
    }

    private func actionSaveEdit() {
        store.create(data) { newProject in
            store.load()
            isPresented = false
        }
    }
}

struct ProjectList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
