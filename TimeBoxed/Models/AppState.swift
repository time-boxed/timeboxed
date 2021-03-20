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

    case historyFetch
    case historySet(results: Pomodoro.List)
    case historyCreate(data: Pomodoro)
    case historyUpdate(data: Pomodoro)
    case historyDate(id: Int, date: Date)
    case historyDelete(offset: IndexSet)

    case favoritesFetch
    case favoritesSet(results: Favorite.List)
    case favoriteState(param: Favorite)
    case favoriteCreate(data: Favorite.Data)
    case favoriteUpdate(update: Favorite)
    case favoriteDelete(delete: Favorite)

    case projectsFetch
    case projectsSet(results: Project.List)
    case projectCreate(data: Project.Data)
    case projectUpdate(project: Project)
    case projectDelete(offset: IndexSet)

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
        return AppAction.historyFetch.eraseToAnyPublisher()
    case .loginRemove(let offset):
        offset.forEach { key in
            let login = state.users.remove(at: key)
            if login == state.login {
                state.login = state.users.first
            }
        }

    //MARK:- Pomodoro
    case .historyFetch:
        guard let login = state.login else { return nil }
        var request: Request<Pomodoro.List> = login.request(path: "/api/pomodoro", method: .get([]))
        request.addBasicAuth(login: login)
        return URLSession.shared.publisher(for: request)
            .map { AppAction.historySet(results: $0) }
            .catch { Just(AppAction.showError(result: $0)) }
            .eraseToAnyPublisher()
    case .historySet(let results):
        state.pomodoros = results.results.sorted { $0.start > $1.start }
    case .historyCreate(data: let data):
        guard let login = state.login else { return nil }
        var request: Request<Pomodoro> = login.request(path: "/api/pomodoro", post: data)
        request.addBasicAuth(login: login)
        return URLSession.shared.publisher(for: request)
            .map(mapPomodoro)
            .catch { Just(AppAction.showError(result: $0)) }
            .eraseToAnyPublisher()
    case .historyUpdate(data: let pomodoro):
        guard let login = state.login else { return nil }
        var request: Request<Pomodoro> = login.request(path: "/api/pomodoro/\(pomodoro.id)", put: pomodoro)
        request.addBasicAuth(login: login)
        return URLSession.shared.publisher(for: request)
            .map(mapPomodoro)
            .catch { Just(AppAction.showError(result: $0)) }
            .eraseToAnyPublisher()
    case .historyDate(id: let id, date: let date):
        guard let login = state.login else { return nil }
        let data = Pomodoro.DateRequest(end: date)
        var request: Request<Pomodoro> = login.request(path: "/api/pomodoro/\(id)", patch: data)
        request.addBasicAuth(login: login)
        return URLSession.shared.publisher(for: request)
            .map(mapPomodoro)
            .catch { Just(AppAction.showError(result: $0)) }
            .eraseToAnyPublisher()
    case .historyDelete(offset: let offset):
        print(offset)

    //MARK:- Favorites
    case .favoritesFetch:
        guard let login = state.login else { return nil }
        var request: Request<Favorite.List> = login.request(path: "/api/favorite", method: .get([]))
        request.addBasicAuth(login: login)
        return URLSession.shared.publisher(for: request)
            .map { AppAction.favoritesSet(results: $0) }
            .catch { Just(AppAction.showError(result: $0)) }
            .eraseToAnyPublisher()
    case .favoriteUpdate(update: let favorite):
        guard let login = state.login else { return nil }
        var request: Request<Favorite.List> = login.request(
            path: "/api/favorite/\(favorite.id)", put: favorite)
        request.addBasicAuth(login: login)
        print(request)
        return AppAction.favoritesFetch.eraseToAnyPublisher()
    case .favoriteDelete(delete: let favorite):
        guard let login = state.login else { return nil }
        var request: Request<Favorite.List> = login.request(
            path: "/api/favorite/\(favorite.id)", method: .delete)
        request.addBasicAuth(login: login)
        print(request)
        return AppAction.historyFetch.eraseToAnyPublisher()
    case .favoriteState(param: let favorite):
        guard let login = state.login else { return nil }
        var request: Request<Pomodoro> = login.request(
            path: "/api/favorite/\(favorite.id)/start", method: .post(nil))
        request.addBasicAuth(login: login)
        // TODO: Fix
        state.tab = .countdown
        return AppAction.historyFetch.eraseToAnyPublisher()
    //        return URLSession.shared.publisher(for: request)
    //            .map { AppAction.loadHistory }
    //            .catch { Just(AppAction.showError(result: $0)) }
    //            .eraseToAnyPublisher()

    case .favoriteCreate(let data):
        guard let login = state.login else { return nil }
        var request: Request<Favorite> = login.request(path: "/api/favorite", post: data)
        request.addBasicAuth(login: login)
        // TODO: Fix
        return AppAction.favoritesFetch.eraseToAnyPublisher()
    //        return URLSession.shared.publisher(for: request)
    //            .map {  AppAction.loadFavorites }
    //            .catch { Just(AppAction.showError(result: $0)) }
    //            .eraseToAnyPublisher()

    case .favoritesSet(let results):
        state.favorites = results.results.sorted { $0.count > $1.count }


    // MARK:- Projects
    case .projectsSet(results: let projects):
        state.projects = projects.results
    case .projectsFetch:
        guard let login = state.login else { return nil }
        var request: Request<Project.List> = login.request(path: "/api/project", method: .get([]))
        request.addBasicAuth(login: login)
        return URLSession.shared.publisher(for: request)
            .map { AppAction.projectsSet(results: $0) }
            .catch { Just(AppAction.showError(result: $0)) }
            .eraseToAnyPublisher()

    case .projectCreate(let data):
        guard let login = state.login else { return nil }
        var request: Request<Project> = login.request(path: "/api/project", post: data)
        request.addBasicAuth(login: login)
        return URLSession.shared.publisher(for: request)
            .map(mapProject)
            .catch { AppAction.showError(result: $0).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .projectUpdate(let project):
        guard let login = state.login else { return nil }
        var request: Request<Project> = login.request(path: "/api/project/\(project.id)", put: project)
        request.addBasicAuth(login: login)
        return URLSession.shared.publisher(for: request)
            .map(mapProject)
            .catch { AppAction.showError(result: $0).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    case .projectDelete(let offset):
        print(offset)
    }

    return nil
}

func mapPomodoro(pomodoro: Pomodoro) -> AppAction {
    return .historyFetch
}

func mapProject(project: Project) -> AppAction {
    return .projectsFetch
}

typealias AppStore = Store<AppState, AppAction, AppEnvironment>
