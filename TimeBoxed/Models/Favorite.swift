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
    let count: Int

    struct List: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Favorite]
    }
}

final class FavoriteStore: ObservableObject {
    @Published private(set) var favorites = [Favorite]()
    private var cancellable: AnyCancellable?

    func fetch() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        cancellable = URLSession.shared.dataTaskPublisher(path: "/api/favorite")
            .map { $0.data }
            .decode(type: Favorite.List.self, decoder: decoder)
            .map(\.results)
            .eraseToAnyPublisher()
            .replaceError(with: [])
            .map { $0.sorted { $0.count > $1.count } }
            .receive(on: DispatchQueue.main)
            .assign(to: \.favorites, on: self)
    }
}