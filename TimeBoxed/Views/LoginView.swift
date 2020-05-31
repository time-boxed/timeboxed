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
    @ObservedObject var userSettings = UserSettings()
    @Environment(\.presentationMode) var presentation

    @State var username: String = ""
    @State var password: String = ""
    @State private var cancellable: AnyCancellable?

    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            TextField("Login", text: $username)
                .padding()
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .keyboardType( /*@START_MENU_TOKEN@*/.emailAddress /*@END_MENU_TOKEN@*/)
            SecureField("Password", text: $password)
                .padding()
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action: Login) {
                Text("LOGIN")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
        }
    }

    func Login() {
        cancellable = URLSession.shared
            .dataTaskPublisher(path: "/api/pomodoro", login: username, password: password)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (error) in
                    print(error)
                },
                receiveValue: { _ in
                    self.userSettings.users.append(self.username)
                    self.userSettings.current_user = self.username

                    Settings.keychain.set(self.password, for: self.username)
                    self.presentation.wrappedValue.dismiss()
                })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
