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

final class ProjectStore: LoadableObject {
    @Published private(set) var state = LoadingState<[Project]>.idle
    private var subscriptions = Set<AnyCancellable>()

    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
            state = .failed(error)
        }
    }

    private func onReceive(_ batch: Project.List) {
        state = .loaded(batch.results)
    }

    func load() {
        state = .loading
        URLRequest.request(path: "/api/project", qs: ["limit": 50])
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Project.List.self, decoder: JSONDecoder.djangoDecoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive, receiveValue: onReceive)
            .store(in: &subscriptions)
    }

    func update(project: Project, receiveValue: @escaping ((Project) -> Void)) {
        var request = URLRequest.request(path: "/api/project/\(project.id)")
        request.httpMethod = "PUT"
        request.addBody(object: project)
        request.dataTaskPublisher()
            .map { $0.data }
            .decode(type: Project.self, decoder: JSONDecoder.djangoDecoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive, receiveValue: receiveValue)
            .store(in: &subscriptions)
    }

    func delete(at offset: IndexSet) {
        // Stub
    }

    func create(_ object: Project.Data, completion: @escaping ((Project) -> Void)) {
        var request = URLRequest.request(path: "/api/project")
        request.httpMethod = "POST"
        request.addBody(object: object)

        request
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Project.self, decoder: JSONDecoder.djangoDecoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive, receiveValue: completion)
            .store(in: &subscriptions)
    }
}
