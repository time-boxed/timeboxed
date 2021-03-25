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

    @EnvironmentObject var store: AppStore

    var body: some View {
        Form {
            TextField("Username", text: $newLogin)
            SecureField("Password", text: $password)
            Button("Login", action: loginAction)
                .buttonStyle(ActionButtonStyle())
                .modifier(CenterModifier())
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
        store.send(.login(login: newLogin, password: password))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
