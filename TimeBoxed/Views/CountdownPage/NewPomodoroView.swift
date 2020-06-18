//
//  NewPomodoroView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct NewPomodoroView: View {
    @ObservedObject var store = PomodoroStore.shared
    @State var isSaveDisabled = true

    class Model: ObservableObject {
        @Published var title: String = ""
        @Published var category: String = ""
        @State var isSaveDisabled = true

        lazy var titleValidation: ValidationPublisher = {
            $title.nonEmptyValidator("Required Title")
        }()
        lazy var categoryValidation: ValidationPublisher = {
            $category.nonEmptyValidator("Required Category")
        }()

        lazy var canSubmit: ValidationPublisher = {
            Publishers.CombineLatest(titleValidation, categoryValidation).map { v1, v2 in
                //                print("firstNameValidation: \(v1)")
                //                print("lastNamesValidation: \(v2)")
                return [v1, v2].allSatisfy { $0.isSuccess } ? .success : .failure(message: "")
            }.eraseToAnyPublisher()
        }()

    }
    @ObservedObject var model = Model()

    var body: some View {
        Section(header: Text("New")) {
            TextField("Title", text: $model.title)
                .validation(model.titleValidation)

            TextField("Category", text: $model.category)
                .validation(model.categoryValidation)

            Button(action: actionSubmit25) {
                Text("25 Min")
            }
            .buttonStyle(ActionButtonStyle())
            .modifier(CenterModifier())
            .disabled(model.isSaveDisabled)

            Button(action: actionSubmit60) {
                Text("60 Min")
            }
            .buttonStyle(ActionButtonStyle())
            .modifier(CenterModifier())
            .disabled(model.isSaveDisabled)
        }
        .onReceive(model.canSubmit) { validation in
            self.isSaveDisabled = !validation.isSuccess
        }
    }

    func submitPomodoro(duration: TimeInterval) {
        let pomodoro = Pomodoro(
            id: 0, title: model.title, start: Date(), end: Date() + duration,
            category: model.category, memo: ""
        )
        store.create(pomodoro) { _ in
            self.model.title = ""
            self.model.category = ""
        }
    }

    func actionSubmit25() {
        submitPomodoro(duration: 25 * 60)
    }

    func actionSubmit60() {
        submitPomodoro(duration: 60 * 60)
    }
}

struct NewPomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        NewPomodoroView()
    }
}
