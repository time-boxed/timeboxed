//
//  AppState.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2021/03/20.
//  Copyright © 2021 Paul Traylor. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

struct AppEnvironment {
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
}

struct AppState {
    @AppStorage("current_user") var login: Login?
    @AppStorage("users") var users: [Login] = []
    var error: Swift.Error?
    var tab = ContentView.Tab.countdown

    var pomodoros: [Pomodoro] = []
    var favorites: [Favorite] = []
    var projects: [Project] = []
}

enum AppAction {
    case login(login: Login, password: String)
    case loginSave(login: Login, password: String)
    case loginRemove(offset: IndexSet)
    case loginSet(user: Login)

    case history(HistoryAction)
    case favorite(FavoriteAction)
    case project(ProjectAction)

    case tabSet(tab: ContentView.Tab)
    case showError(result: Swift.Error)
}

extension AppAction {
    func eraseToAnyPublisher() -> AnyPublisher<AppAction, Never> {
        return Just(self).eraseToAnyPublisher()
    }
}

func appReducer(state: inout AppState, action: AppAction, environment: AppEnvironment)
    -> AnyPublisher<AppAction, Never>?
{
    switch action {
    case .showError(result: let error):
        state.error = error
    case .tabSet(let tab):
        state.tab = tab

    case .login(let login, let password):
        var request: Request<Pomodoro.List> = login.request(path: "/api/pomodoro", method: .get([]))
        request.addBasicAuth(username: login.username, password: password)
        return AppAction.loginSave(login: login, password: password).eraseToAnyPublisher()

    case .loginSave(var login, let password):
        login.password = password
        state.users.append(login)
        return AppAction.loginSet(user: login).eraseToAnyPublisher()

    case .loginSet(let user):
        state = .init()
        state.login = user
        return AppAction.history(.fetch).eraseToAnyPublisher()
    case .loginRemove(let offset):
        offset.forEach { key in
            let login = state.users.remove(at: key)
            if login == state.login {
                state.login = state.users.first
            }
        }

    case .history(let action):
        return action.reducer(state: &state, environment: environment)
    case .favorite(let action):
        return action.reducer(state: &state, environment: environment)
    case .project(let action):
        return action.reducer(state: &state, environment: environment)
    }
    return nil
}

typealias AppStore = Store<AppState, AppAction, AppEnvironment>
