//
//  ReportView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/15.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ReportByProject: View {
    static var defaultProject = Project(
        id: "", name: "No Project", html_link: URL(string: "https://example.com")!, url: nil,
        color: .black, active: true, memo: "", duration: 0)

    var groups: [(key: Project, value: [Pomodoro])]
    var body: some View {
        List {
            ForEach(groups, id: \.key) { project, pomodoros in
                Section(header: Text(project.name)) {
                    IntervalView(elapsed: pomodoros.map { $0.end.distance(to: $0.start) })
                }
            }
        }
        Text("Project")
    }
    init(pomodoros: [Pomodoro]) {
        self.groups = Dictionary(
            grouping: pomodoros,
            by: { $0.project ?? ReportByProject.defaultProject }
        ).sorted { $0.key.name > $1.key.name }
    }
}

struct ReportView: View {
    var date: Date
    var pomodoros: [Pomodoro]

    var body: some View {
        VStack {
            DateView(date: date)
            ReportByProject(pomodoros: pomodoros)
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(date: Date(), pomodoros: [])
    }
}
