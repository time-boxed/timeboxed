//
//  LoginView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI
import Combine

struct LoginView: View {
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
        var request = URLComponents()
        let parts = username.components(separatedBy: "@")
        request.host = parts[1]
        request.path = "/api/pomodoro"
        request.scheme = "https"
        
        request.user = parts[0]
        request.password = password
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request.url!)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { (error) in
                print(error)
            }, receiveValue: { _ in
                Settings.defaults.set(value: self.username, forKey: .currentUser)
                Settings.keychain.set(self.password, for: self.username)
            })
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
