//
//  ProjectRowView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/11.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ProjectRowView: View {
    @EnvironmentObject var store: ProjectStore
    
    var id: String
    var project: Project? {
        return store.projects.first(where: { $0.id == id })
    }
    
    @ViewBuilder
    var body: some View {
        if project == nil {
            Text(id)
                .onAppear(perform: store.fetch)
        } else {
            Text(project!.name)
                .accentColor(project!.color)
        }
    }
}

struct ProjectRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectRowView(id: "")
    }
}
