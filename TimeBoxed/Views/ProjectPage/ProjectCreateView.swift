//
//  ProjectCreateView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/12.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct AddProjectButton: View {
    @State var isPresenting = false

    var body: some View {
        Button("Add") {
            isPresenting.toggle()
        }.sheet(isPresented: $isPresenting) {
            ProjectCreateSheet()
        }
    }
}

struct ProjectCreateSheet: View {
    var body: some View {
        Text( /*@START_MENU_TOKEN@*/"Hello, World!" /*@END_MENU_TOKEN@*/)
    }
}

struct ProjectCreateView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectCreateSheet()
    }
}
