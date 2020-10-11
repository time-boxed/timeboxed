//
//  ProjectRowView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/11.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

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
