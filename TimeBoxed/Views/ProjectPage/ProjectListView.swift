//
//  ProjectListView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ProjectRow: View {
    let project: Project
    var body: some View {
        VStack(alignment: .leading) {
            ProjectRowView(project: project)
                .font(.title)
            DurationView(duration: project.duration)
                .font(.footnote)
        }
    }
}

struct ProjectListSorted: View {
    @EnvironmentObject var store: AppStore
    var projects: [Project]
    var body: some View {
        List {
            ForEach(projects) { project in
                NavigationLink(destination: ProjectDetailView(project: project)) {
                    ProjectRow(project: project)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button("Delete", role: .destructive) {
                        store.send(.project(.delete(project: project)))
                    }
                }
            }
        }
    }

    init(byDuration: [Project]) {
        projects = byDuration.sorted { $0.duration > $1.duration }
    }

    init(byName: [Project]) {
        projects = byName.sorted { $0.name > $1.name }
    }
}

struct ProjectListView: View {
    @EnvironmentObject var store: AppStore

    @State private var isPresented = false
    @State private var data = Project.Data()
    @AppStorage("projectSort") private var sorting = Sorting.alphabetic

    enum Sorting: String {
        case alphabetic
        case duration
    }

    var body: some View {
        NavigationView {
            sorting.content(projects: store.state.projects)
            .task { await fetch() }
            .refreshable { await fetch() }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Projects")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Add", action: actionShowAdd)
                    Picker("Sorting", selection: $sorting) {
                        Text("Alphabetic").tag(Sorting.alphabetic)
                        Text("Duration").tag(Sorting.duration)
                    }.pickerStyle(MenuPickerStyle())
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
        store.send(.project(.create(data: data)))
        isPresented = false
    }

    private func fetch() async {
        store.send(.project(.fetch))
    }
}

extension ProjectListView.Sorting {
    @ViewBuilder func content(projects: [Project]) -> some View {
        switch self {
        case .alphabetic:
            ProjectListSorted(byName: projects)
        case .duration:
            ProjectListSorted(byDuration: projects)
        }
    }
}

struct ProjectList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
