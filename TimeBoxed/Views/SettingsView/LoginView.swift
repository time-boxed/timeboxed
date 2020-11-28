//
//  LoginView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import KeychainAccess
import SwiftUI

struct LoginView: View {
    @State var newLogin: Login = ""
    @State var password: String = ""

    @EnvironmentObject var userSettings: UserSettings
    @State private var subscriptions = Set<AnyCancellable>()

    var body: some View {
        Form {
            TextField("Username", text: $newLogin)
            SecureField("Password", text: $password)
            Button("Login", action: loginAction)
                .disabled(
                    [
                        newLogin.contains("@"),
                        newLogin.contains("."),
                        newLogin.count > 0,
                        password.count > 0,
                    ].contains(false))
        }
    }

    func loginAction() {
        var request = newLogin.request(for: "/api/pomodoro", qs: [])
        request.addBasicAuth(username: newLogin.username, password: password)

        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive, receiveValue: onRecieve)
            .store(in: &subscriptions)
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
        userSettings.current_user = newLogin
        userSettings.users.append(newLogin)
        try? Settings.keychain.set(password, key: newLogin)
        userSettings.currentTab = .countdown
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
