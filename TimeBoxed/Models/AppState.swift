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
    case saveLogin(login: Login, password: String)
    //    case userRemove(user: Login)
    case userRemove(offset: IndexSet)
    case setUser(user: Login)

    case loadHistory
    case setHistory(results: Pomodoro.List)

    case loadFavorites
    case setFavorites(results: Favorite.List)
    case startFavorite(param: Favorite)
    case createFavorite(data: Favorite.Data)
    case favoriteUpdate(update: Favorite)
    case favoriteDelete(delete: Favorite)

    case projectsLoad
    case projectsSet(results: Project.List)
    case projectCreate(data: Project.Data)
    case projectUpdate(project: Project)
    case projectDelete(offset: IndexSet)

    case setTab(tab: ContentView.Tab)
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

extension AppAction {
    func toPublisher() -> AnyPublisher<AppAction, Never> {
        return Just(self).eraseToAnyPublisher()
    }
}

func appReducer(state: inout AppState, action: AppAction, environment: AppEnvironment)
    -> AnyPublisher<AppAction, Never>?
{
    switch action {
    case .showError(result: let error):
        print(error.localizedDescription)
    case .setTab(let tab):
        state.tab = tab

    case .login(let login, let password):
        var request: Request<Pomodoro.List> = login.request(path: "/api/pomodoro", method: .get([]))
        request.addBasicAuth(username: login.username, password: password)
        return Just(AppAction.saveLogin(login: login, password: password)).eraseToAnyPublisher()

    case .saveLogin(var login, let password):
        login.password = password
        state.users.append(login)
        return Just(AppAction.setUser(user: login)).eraseToAnyPublisher()

    case .setUser(let user):
        state = .init()
        state.login = user
        return Just(AppAction.loadHistory).eraseToAnyPublisher()
    case .userRemove(let offset):
        offset.forEach { key in
            let login = state.users.remove(at: key)
            if login == state.login {
                state.login = state.users.first
            }
        }

    case .loadHistory:
        guard let login = state.login else { return nil }
        var request: Request<Pomodoro.List> = login.request(path: "/api/pomodoro", method: .get([]))
        request.addBasicAuth(login: login)
        return URLSession.shared.publisher(for: request)
            .map { AppAction.setHistory(results: $0) }
            .catch { Just(AppAction.showError(result: $0)) }
            .eraseToAnyPublisher()
    case .setHistory(let results):
        state.pomodoros = results.results.sorted { $0.start > $1.start }

    case .loadFavorites:
        guard let login = state.login else { return nil }
        var request: Request<Favorite.List> = login.request(path: "/api/favorite", method: .get([]))
        request.addBasicAuth(login: login)
        return URLSession.shared.publisher(for: request)
            .map { AppAction.setFavorites(results: $0) }
            .catch { Just(AppAction.showError(result: $0)) }
            .eraseToAnyPublisher()
    case .favoriteUpdate(update: let favorite):
        guard let login = state.login else { return nil }
        var request: Request<Favorite.List> = login.request(
            path: "/api/favorite/\(favorite.id)", put: favorite)
        request.addBasicAuth(login: login)
        print(request)
        return Just(AppAction.loadFavorites).eraseToAnyPublisher()
    case .favoriteDelete(delete: let favorite):
        guard let login = state.login else { return nil }
        var request: Request<Favorite.List> = login.request(
            path: "/api/favorite/\(favorite.id)", method: .delete)
        request.addBasicAuth(login: login)
        print(request)
        return Just(AppAction.loadHistory).eraseToAnyPublisher()
    case .startFavorite(param: let favorite):
        guard let login = state.login else { return nil }
        var request: Request<Pomodoro> = login.request(
            path: "/api/favorite/\(favorite.id)/start", method: .post(nil))
        request.addBasicAuth(login: login)
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
        request.addBasicAuth(login: login)
        // TODO: Fix
        return Just(AppAction.loadFavorites).eraseToAnyPublisher()
    //        return URLSession.shared.publisher(for: request)
    //            .map {  AppAction.loadFavorites }
    //            .catch { Just(AppAction.showError(result: $0)) }
    //            .eraseToAnyPublisher()

    case .setFavorites(let results):
        state.favorites = results.results.sorted { $0.count > $1.count }


    // MARK:- Projects
    case .projectsSet(results: let projects):
        state.projects = projects.results
    case .projectsLoad:
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
            .catch { AppAction.showError(result: $0).toPublisher() }
            .eraseToAnyPublisher()
    case .projectUpdate(let project):
        guard let login = state.login else { return nil }
        var request: Request<Project> = login.request(path: "/api/project/\(project.id)", put: project)
        request.addBasicAuth(login: login)
        return URLSession.shared.publisher(for: request)
            .map(mapProject)
            .catch { AppAction.showError(result: $0).toPublisher() }
            .eraseToAnyPublisher()
    case .projectDelete(let offset):
        print(offset)
    }

    return nil
}

func mapProject(project: Project) -> AppAction {
    return .projectsLoad
}

typealias AppStore = Store<AppState, AppAction, AppEnvironment>
