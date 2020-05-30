//
//  Pomodoro.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/03.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import Foundation

struct Pomodoro: Codable, Identifiable {
    let id: Int
    var title: String
    var start: Date
    var end: Date
    var category: String
    var memo: String?

    struct List: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Pomodoro]
    }
}

extension Pomodoro {
    static func list() -> AnyPublisher<[Pomodoro], Error> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return URLSession.shared.dataTaskPublisher(path: "/api/pomodoro")
            .map { $0.data }
            .decode(type: Pomodoro.List.self, decoder: decoder)
            .map(\.results)
            .eraseToAnyPublisher()
    }
}
