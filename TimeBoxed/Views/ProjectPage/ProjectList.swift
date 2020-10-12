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
        Section {
            ForEach(store.projects, id: \.id) { project in
                NavigationLink(destination: ProjectDetailView(project: project)) {
                    Text(project.name)
                        .foregroundColor(project.color)
                }
            }
        }
    }

    var stateStatus: AnyView {
        switch store.state {
        case .idle:
            return Text("No result").eraseToAnyView()
        case .failed(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loading:
            return Text("Loading").eraseToAnyView()
        case .loaded:
            return EmptyView().eraseToAnyView()
        }
    }

    var body: some View {
        NavigationView {
            List {
                HStack {
                    Button("Reload", action: store.fetch)
                    Spacer()
                    stateStatus
                }
                fetchedView
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
