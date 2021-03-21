//
//  Project.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/06.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

struct Project: Codable, Identifiable, Equatable, Hashable {
    let id: String
    var name: String
    let html_link: URL
    var url: URL?
    var color: Color
    var active: Bool
    var memo: String
    var duration: TimeInterval

    struct List: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Project]
    }
}

enum ProjectAction {
    case fetch
    case set(results: Project.List)
    case create(data: Project.Data)
    case update(project: Project)
    case delete(offset: IndexSet)
}

func mapProject(project: Project) -> AppAction {
    return .project(.fetch)
}

extension ProjectAction {
    func reducer(state: inout AppState, environment: AppEnvironment)
        -> AnyPublisher<AppAction, Never>?
    {
        guard let login = state.login else { return nil }
        switch self {

        case .fetch:
            var request: Request<Project.List> = login.request(
                path: "/api/project", method: .get([]))
            request.addBasicAuth(login: login)
            return URLSession.shared.publisher(for: request)
                .map { AppAction.project(.set(results: $0)) }
                .catch { Just(AppAction.errorShow(result: $0)) }
                .eraseToAnyPublisher()
        case .set(let projects):
            state.projects = projects.results
        case .create(let data):
            var request: Request<Project> = login.request(path: "/api/project", post: data)
            request.addBasicAuth(login: login)
            return URLSession.shared.publisher(for: request)
                .map(mapProject)
                .catch { AppAction.errorShow(result: $0).eraseToAnyPublisher() }
                .eraseToAnyPublisher()
        case .update(let project):
            var request: Request<Project> = login.request(
                path: "/api/project/\(project.id)", put: project)
            request.addBasicAuth(login: login)
            return URLSession.shared.publisher(for: request)
                .map(mapProject)
                .catch { AppAction.errorShow(result: $0).eraseToAnyPublisher() }
                .eraseToAnyPublisher()
        case .delete(let offset):
            // TODO: Implement Delete
            print(offset)
        }
        return nil
    }
}
