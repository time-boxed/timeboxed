//
//  LoginView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.presentationMode) var presentation

    @State var isSaveDisabled = true
    @State private var cancellable: AnyCancellable?

    class Model: ObservableObject {
        @Published var username: String = ""
        @Published var password: String = ""

        lazy var usernameValidator: ValidationPublisher = {
            $username.matcherValidation(".+@.+\\..+", "Requires Username")
        }()
        lazy var passwordValidation: ValidationPublisher = {
            $password.nonEmptyValidator("Required Password")
        }()

        lazy var canSubmit: ValidationPublisher = {
            Publishers.CombineLatest(usernameValidator, passwordValidation).map { v1, v2 in
                //                print("firstNameValidation: \(v1)")
                //                print("lastNamesValidation: \(v2)")
                return [v1, v2].allSatisfy { $0.isSuccess } ? .success : .failure(message: "")
            }.eraseToAnyPublisher()
        }()
    }
    @ObservedObject var model = Model()

    var body: some View {
        //        Form {
        VStack {

            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.semibold)
            TextField("Login", text: $model.username)
                .validation(model.usernameValidator)
                .textContentType(.emailAddress)
                .keyboardType( /*@START_MENU_TOKEN@*/.emailAddress /*@END_MENU_TOKEN@*/)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .autocapitalization(.none)
            SecureField("Password", text: $model.password)
                .validation(model.passwordValidation)
                .textContentType(.password)
                .keyboardType(.asciiCapable)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action: submitLogin) {
                Text("LOGIN")
            }
            .buttonStyle(LoginButtonStyle())
            .disabled(self.isSaveDisabled)

            //            }
        }.padding()
            .onReceive(model.canSubmit) { (validation) in
                self.isSaveDisabled = !validation.isSuccess
            }
    }

    private func onReceive(completion: Subscribers.Completion<URLError>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }

    private func onRecieve(data: Data, response: URLResponse) {
        userSettings.users.append(model.username)
        userSettings.current_user = model.username

        Settings.keychain.set(model.password, for: model.username)
        presentation.wrappedValue.dismiss()
    }

    func submitLogin() {
        cancellable = URLRequest.request(
            path: "/api/pomodoro", login: model.username, password: model.password, qs: [:]
        )
        .dataTaskPublisher()
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: onReceive, receiveValue: onRecieve)
    }
}

#if DEBUG

    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView().previewDevice(PreviewData.device)
        }
    }

#endif
