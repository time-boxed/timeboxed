//
//  Favorite.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/29.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import Foundation

struct Favorite: Codable, Identifiable {
    let id: Int
    var title: String
    var duration: TimeInterval
    var memo: String?
    var icon: URL?
    var html_link: URL
    var url: URL?
    var count: Int
    var project: Project?

    struct List: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Favorite]
    }
}

enum FavoriteAction {
    case fetch
    case set(results: Favorite.List)
    case start(param: Favorite)
    case create(data: Favorite.Data)
    case update(update: Favorite)
    case delete(delete: Favorite)
}

func mapFavorite(favorite: Favorite) -> AppAction {
    return .favorite(.fetch)
}

extension FavoriteAction {
    func reducer(state: inout AppState, environment: AppEnvironment)
        -> AnyPublisher<AppAction, Never>?
    {
        guard let login = state.login else { return nil }
        switch self {
        case .fetch:
            var request: Request<Favorite.List> = login.request(
                path: "/api/favorite", method: .get([]))
            request.addBasicAuth(login: login)
            return URLSession.shared.publisher(for: request)
                .map { AppAction.favorite(.set(results: $0)) }
                .catch { Just(AppAction.errorShow(result: $0)) }
                .eraseToAnyPublisher()
        case .set(let results):
            state.favorites = results.results.sorted { $0.count > $1.count }
        case .start(let favorite):
            var request: Request<Pomodoro> = login.request(
                path: "/api/favorite/\(favorite.id)/start", method: .post(nil))
            request.addBasicAuth(login: login)
            state.tab = .countdown
            return URLSession.shared.publisher(for: request)
                .map(mapPomodoro)
                .catch { Just(AppAction.errorShow(result: $0)) }
                .eraseToAnyPublisher()
        case .create(let data):
            var request: Request<Favorite> = login.request(path: "/api/favorite", post: data)
            request.addBasicAuth(login: login)
            return URLSession.shared.publisher(for: request)
                .map(mapFavorite)
                .catch { Just(AppAction.errorShow(result: $0)) }
                .eraseToAnyPublisher()
        case .update(let favorite):
            var request: Request<Favorite.List> = login.request(
                path: "/api/favorite/\(favorite.id)", put: favorite)
            request.addBasicAuth(login: login)
            print(request)
            return AppAction.favorite(.fetch).eraseToAnyPublisher()
        case .delete(let favorite):
            var request: Request<Favorite.List> = login.request(
                path: "/api/favorite/\(favorite.id)", method: .delete)
            request.addBasicAuth(login: login)
            print(request)
            return AppAction.favorite(.fetch).eraseToAnyPublisher()
        }
        return nil
    }
}
