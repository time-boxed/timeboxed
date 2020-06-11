//
//  ProjectList.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ProjectList: View {
    @EnvironmentObject var store: ProjectStore
    
    var body: some View {
        NavigationView {
            List(store.projects, id: \.id) { project in
                NavigationLink(destination: ProjectDetailView(project: project)) {
                    Text(project.name)
                        .foregroundColor(project.color)
                }
            }
            .navigationBarTitle("Projects")
        }
        .onAppear(perform: store.fetch)
    }
}

struct ProjectList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectList()
    }
}
