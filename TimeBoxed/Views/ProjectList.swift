//
//  ProjectList.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ProjectList: View {
    @ObservedObject var store = ProjectStore.shared

    var body: some View {
        List(store.projects, id: \.id) { project in
            Text(project.name)
                .foregroundColor(project.color)
        }
        .onAppear(perform: store.fetch)
    }
}

struct ProjectList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectList()
    }
}
