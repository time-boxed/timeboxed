//
//  ProjectRowView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/11.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ProjectOptionalView: View {
    var project: Project?

    var body: some View {
        if let project = project {
            ProjectRowView(project: project)
        } else {
            Text("No Project")
        }
    }
}

struct ProjectRowView: View {
    var project: Project

    @ViewBuilder
    var body: some View {
        Text(project.name)
            .foregroundColor(project.color)
    }
}

//struct ProjectRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectRowView(id: "")
//    }
//}
