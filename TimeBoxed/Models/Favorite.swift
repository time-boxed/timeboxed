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
    let title: String
    let duration: TimeInterval
    let memo: String?
    let icon: URL?
    let html_link: URL
    let url: URL?

    struct List: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Favorite]
    }
}

extension Favorite: API {
    static func list() -> AnyPublisher<[Favorite], Error> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return request(path: "/api/favorite")
            .map { $0.data }
            .decode(type: Favorite.List.self, decoder: decoder)
            .map(\.results)
            .eraseToAnyPublisher()
    }
}
