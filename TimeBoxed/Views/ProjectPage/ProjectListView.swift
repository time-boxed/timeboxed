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

    var body: some View {
        NavigationView {
            List {
                AsyncContentView(source: store) { projects in
                    Section {
                        ForEach(projects.sorted { $0.duration > $1.duration }) { project in
                            NavigationLink(destination: ProjectDetailView(project: project)) {
                                VStack(alignment: .leading) {
                                    ProjectRowView(project: project)
                                        .font(.title)
                                    DurationView(duration: project.duration)
                                        .font(.footnote)
                                }
                            }
                        }.onDelete(perform: store.delete)
                    }
                }

            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .bottomBar) {
                    AddProjectButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ReloadButton(source: store)
                }
            }
        }
    }
}

struct ProjectList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
