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
    var tab = ContentView.Tab.countdown

    var pomodoros: [Pomodoro] = []
    var favorites: [Favorite] = []
}

enum AppAction {
    case login(login: Login, password: String)
    case saveLogin(login: Login, password: String)
    case setTab(tab: ContentView.Tab)

    case loadHistory
    case setHistory(results: Pomodoro.List)

    case loadFavorites
    case setFavorites(results: Favorite.List)
    case startFavorite(param: Favorite)
    case createFavorite(data: Favorite.Data)
    case favoriteUpdate(update: Favorite)
    case favoriteDelete(delete: Favorite)

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
    case .setTab(tab: let tab):
        state.tab = tab

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

    case .loadFavorites:
        guard let login = state.login else { return nil }
        var request: Request<Favorite.List> = login.request(path: "/api/favorite", method: .get([]))
        request.addBasicAuth(username: login.username, password: login.password)
        return URLSession.shared.publisher(for: request)
            .map { AppAction.setFavorites(results: $0) }
            .catch { Just(AppAction.showError(result: $0)) }
            .eraseToAnyPublisher()
    case .favoriteUpdate(update: let favorite):
        guard let login = state.login else { return nil }
        var request: Request<Favorite.List> = login.request(path: "/api/favorite/\(favorite.id)", put: favorite)
        request.addBasicAuth(username: login.username, password: login.password)
        print(request)
        return Just(AppAction.loadFavorites).eraseToAnyPublisher()
    case .favoriteDelete(delete: let favorite):
        guard let login = state.login else { return nil }
        var request: Request<Favorite.List> = login.request(path: "/api/favorite/\(favorite.id)", method: .delete)
        request.addBasicAuth(username: login.username, password: login.password)
        print(request)
        return Just(AppAction.loadHistory).eraseToAnyPublisher()
    case .startFavorite(param: let favorite):
        guard let login = state.login else { return nil }
        var request: Request<Pomodoro> = login.request(path: "/api/favorite/\(favorite.id)/start", method: .post(nil))
        request.addBasicAuth(username: login.username, password: login.password)
        // TODO: Fix
        state.tab = .countdown
        return Just(AppAction.loadHistory).eraseToAnyPublisher()
//        return URLSession.shared.publisher(for: request)
//            .map { AppAction.loadHistory }
//            .catch { Just(AppAction.showError(result: $0)) }
//            .eraseToAnyPublisher()

    case .createFavorite(let data):
        guard let login = state.login else { return nil }
        var request: Request<Favorite> = login.request(path: "/api/favorite", post: data)
        request.addBasicAuth(username: login.username, password: login.password)
        // TODO: Fix
        return Just(AppAction.loadFavorites).eraseToAnyPublisher()
    //        return URLSession.shared.publisher(for: request)
    //            .map {  AppAction.loadFavorites }
    //            .catch { Just(AppAction.showError(result: $0)) }
    //            .eraseToAnyPublisher()

    case .setFavorites(let results):
        state.favorites = results.results.sorted { $0.count > $1.count }
    }
    return nil
}

typealias AppStore = Store<AppState, AppAction, AppEnvironment>
