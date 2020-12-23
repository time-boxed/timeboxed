//
//  ProjectSelectorView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/11.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ProjectSelectorList: View {
    @EnvironmentObject var store: ProjectStore
    @Environment(\.presentationMode) var presentationMode
    var selected: (Project?) -> Void = { _ in }

    var body: some View {
        List {
            AsyncContentView(source: store) { projects in
                Section {
                    ForEach(projects) { project in
                        Button(action: {
                            selected(project)
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            ProjectRowView(project: project)
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Projects")
    }
}

struct ProjectSelectorView: View {
    @EnvironmentObject var store: ProjectStore

    var project: Project?
    var selected: (Project?) -> Void = { _ in }

    var body: some View {
        NavigationLink(destination: ProjectSelectorList(selected: selected)) {
            ProjectOptionalView(project: project)
                .label(left: "Project")
        }
    }
}

struct ProjectSelector_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSelectorView()
    }
}
