//
//  Project.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/06.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import Foundation

struct Project: Codable, Identifiable {
    let id: Int
    let title: String

    struct List: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Project]
    }
}

final class ProjectStore: ObservableObject {
    var shared = ProjectStore()

    @Published private(set) var projects = [Project]()
    private var cancellable: AnyCancellable?

    func fetch() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        cancellable = URLRequest.request(path: "/api/project")
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Project.List.self, decoder: decoder)
            .map(\.results)
            .eraseToAnyPublisher()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.projects, on: self)
    }
}
