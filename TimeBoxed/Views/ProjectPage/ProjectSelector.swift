//
//  ProjectSelector.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/11.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ProjectSelector: View {
    var project: Project?

    var body: some View {
        NavigationLink(destination: EmptyView()) {
            Group {
                if let project = project {
                    ProjectRowView(project: project)
                } else {
                    Text("No Project")
                }
            }
            .modifier(LabelModifier(label: "Project"))
        }
    }
}

struct ProjectSelector_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSelector()
    }
}
