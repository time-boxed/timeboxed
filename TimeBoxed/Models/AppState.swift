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
    var error: Swift.Error?

    var pomodoros: [Pomodoro] = []
}

enum AppAction {
    case login(login: Login, password: String)
    case saveLogin(login: Login, password: String)

    case loadHistory
    case setHistory(results: Pomodoro.List)

    case showError(result: Swift.Error)

    //    case loadHistory
    //    case setHistory(results: Pomodoro)
    //
    //    case loadFavorites
    //    case setFavorites(results: Favorite)
    //
    //    case loadProjects
    //    case setProjects(results: Project)
}

func appReducer(state: inout AppState, action: AppAction, environment: AppEnvironment)
    -> AnyPublisher<AppAction, Never>?
{
    switch action {
    case .showError(result: let error):
        print(error.localizedDescription)

    case .login:
        print("Login")
    case .saveLogin:
        print("saveLogin")

    case .loadHistory:
        guard let login = state.login else { return nil }
        var request: Request<Pomodoro.List> = login.request(path: "/api/pomodoro", method: .get([]))
        request.addBasicAuth(username: login.username, password: login.password)
        return URLSession.shared.publisher(for: request)
            .map { AppAction.setHistory(results: $0) }
            .catch { Just(AppAction.showError(result: $0)) }
            .eraseToAnyPublisher()
    case .setHistory(let results):
        state.pomodoros = results.results.sorted { $0.start > $1.start }
    }
    return nil
}

typealias AppStore = Store<AppState, AppAction, AppEnvironment>
