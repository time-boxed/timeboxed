//
//  ProjectListView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ProjectListView: View {
    @EnvironmentObject var store: AppStore

    @State private var isPresented = false
    @State private var data = Project.Data()

    var body: some View {
        NavigationView {
            List {
                ForEach(store.state.projects.sorted { $0.duration > $1.duration }) { project in
                    NavigationLink(destination: ProjectDetailView(project: project)) {
                        VStack(alignment: .leading) {
                            ProjectRowView(project: project)
                                .font(.title)
                            DurationView(duration: project.duration)
                                .font(.footnote)
                        }
                    }
                }
                .onDelete(perform: { store.send(.projectDelete(offset: $0)) })

            }
            .onAppear(perform: fetch)
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add", action: actionShowAdd)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reload") {
                        store.send(.projectsLoad)
                    }
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
        store.send(.projectCreate(data: data))
        isPresented = false
    }

    private func fetch() {
        store.send(.projectsLoad)
    }
}

struct ProjectList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
