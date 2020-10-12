//
//  CountdownSectionView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct CountdownSectionView: View {
    @Binding var pomodoro: Pomodoro
    var body: some View {
        Section {
            VStack {
                Text(pomodoro.title)
                    .font(.system(size: 32))

                CountdownView(date: .constant(pomodoro.end))
                    .font(.system(size: 72))

                DateTimeView(label: "Start", date: pomodoro.start)
                DateTimeView(label: "End", date: pomodoro.end)

                ProjectSelectorView(project: pomodoro.project)

                if let project = pomodoro.project {
                    ProjectSelectorView(project: project)
                    NavigationLink(destination: ProjectDetailView(project: project)) {
                        ProjectRowView(project: project)
                            .modifier(LabelModifier(label: "Project"))
                    }
                }

            }.modifier(CenterModifier())

        }
    }
}

#if DEBUG

    struct CountdownSectionView_Previews: PreviewProvider {
        static var previews: some View {
            CountdownSectionView(pomodoro: .constant(PreviewData.pomodoro))
        }
    }

#endif
