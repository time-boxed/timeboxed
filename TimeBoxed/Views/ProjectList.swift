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

    var fetchedView: some View {
        ForEach(store.projects, id: \.id) { project in
            NavigationLink(destination: ProjectDetailView(project: project)) {
                Text(project.name)
                    .foregroundColor(project.color)
            }
        }
    }

    var switchView: AnyView {
        switch store.state {
        case .empty:
            return Text("No Favorites").eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .fetching:
            return Text("Loading").eraseToAnyView()
        case .fetched:
            return
                fetchedView
                .eraseToAnyView()
        }
    }

    var body: some View {
        NavigationView {
            List() {
                Button("Reload", action: self.store.fetch)
                Section() {
                    switchView
                }
            }
            .listStyle(GroupedListStyle())
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
