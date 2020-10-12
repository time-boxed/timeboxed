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
                                ProjectRowView(project: project)
                                Spacer()
                                DurationView(duration: project.duration)
                            }
                        }.onDelete(perform: store.delete)
                    }
                }
                ReloadButton(source: store)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Projects")
            .navigationBarItems(
                leading: EditButton(),
                trailing: AddProjectButton()
            )
        }
    }
}

struct ProjectList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
