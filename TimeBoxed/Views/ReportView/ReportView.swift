//
//  ReportView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/15.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct ReportByProject: View {
    static var defaultProject = Project(
        id: "", name: "No Project", html_link: URL(string: "https://example.com")!, url: nil,
        color: .black, active: true, memo: "", duration: 0)

    var groups: [(key: Project, value: [Pomodoro])]
    var body: some View {
        List {
            ForEach(groups, id: \.key) { project, pomodoros in
                Section(header: Text(project.name)) {
                    IntervalView(elapsed: pomodoros.map { $0.duration })
                }
            }
        }
        Text("Project")
    }
    init(pomodoros: [Pomodoro]) {
        self.groups =
            pomodoros
            .groupByProject()
            .sorted { $0.key.name > $1.key.name }
    }
}

struct ChartByProject: View {
    var data: [Double]
    var body: some View {
        PieChartView(data: data, title: "Report")
    }
    init(pomodoros: [Pomodoro]) {
        self.data =
            pomodoros
            .groupByProject()
            .values
            .map { $0.sum(for: \.duration) }
    }
}

struct ReportView: View {
    var date: Date
    var pomodoros: [Pomodoro]

    var body: some View {
        VStack {
            DateView(date: date)
            ChartByProject(pomodoros: pomodoros)
            ReportByProject(pomodoros: pomodoros)
        }
        .navigationBarTitle(date.debugDescription)
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(date: Date(), pomodoros: [])
    }
}
