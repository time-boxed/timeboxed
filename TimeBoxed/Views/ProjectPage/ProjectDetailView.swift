//
//  ProjectDetailView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/11.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ProjectDetailView: View {
    @State var project: Project

    var body: some View {
        VStack {
            Text(project.name)
                .accentColor(project.color)
            if project.url != nil {
                Text(project.url!.absoluteString)
            }
            Text(project.memo)
            Spacer()
        }
        .navigationBarTitle(project.name)
    }
}

//struct ProjectDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectDetailView()
//    }
//}
