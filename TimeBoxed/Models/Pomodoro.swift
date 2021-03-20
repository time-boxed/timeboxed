//
//  Pomodoro.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/03.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import Foundation

struct Pomodoro: Codable, Identifiable, Equatable {
    let id: Int
    var title: String
    var start: Date
    var end: Date
    var memo: String = ""
    var project: Project?
    var url: URL?

    struct List: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Pomodoro]
    }

    struct DateRequest: Codable {
        let end: Date
    }
}

extension Pomodoro {
    var isActive: Bool {
        return end > Date()
    }
    var duration: TimeInterval {
        return end.distance(to: start)
    }
}

enum HistoryAction {
    case fetch
    case set(Pomodoro.List)
    case create(Pomodoro)
    case update(Pomodoro)
    case date(id: Int, date: Date)
    case delete(offset: IndexSet)
}

func mapPomodoro(pomodoro: Pomodoro) -> AppAction {
    return .history(.fetch)
}

extension HistoryAction {
    func reducer(state: inout AppState, environment: AppEnvironment)
        -> AnyPublisher<AppAction, Never>?
    {
        guard let login = state.login else { return nil }
        switch self {
        case .fetch:
            var request: Request<Pomodoro.List> = login.request(
                path: "/api/pomodoro", method: .get([]))
            request.addBasicAuth(login: login)
            return URLSession.shared.publisher(for: request)
                .map { HistoryAction.set($0) }
                .map { AppAction.history($0) }
                .catch { Just(AppAction.showError(result: $0)) }
                .eraseToAnyPublisher()
        case .set(let results):
            state.pomodoros = results.results.sorted { $0.start > $1.start }
        case .create(let data):
            var request: Request<Pomodoro> = login.request(path: "/api/pomodoro", post: data)
            request.addBasicAuth(login: login)
            return URLSession.shared.publisher(for: request)
                .map(mapPomodoro)
                .catch { Just(AppAction.showError(result: $0)) }
                .eraseToAnyPublisher()
        case .update(let pomodoro):
            var request: Request<Pomodoro> = login.request(
                path: "/api/pomodoro/\(pomodoro.id)", put: pomodoro)
            request.addBasicAuth(login: login)
            return URLSession.shared.publisher(for: request)
                .map(mapPomodoro)
                .catch { Just(AppAction.showError(result: $0)) }
                .eraseToAnyPublisher()
        case .date(let id, let date):
            let data = Pomodoro.DateRequest(end: date)
            var request: Request<Pomodoro> = login.request(path: "/api/pomodoro/\(id)", patch: data)
            request.addBasicAuth(login: login)
            return URLSession.shared.publisher(for: request)
                .map(mapPomodoro)
                .catch { Just(AppAction.showError(result: $0)) }
                .eraseToAnyPublisher()
        case .delete(let offset):
            print(offset)
        }
        return nil
    }
}
