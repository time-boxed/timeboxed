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
    var id: Int
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

typealias FavoriteCompletion = ((Favorite) -> Void)

final class FavoriteStore: API {
    var canLoadNextPage = true

    typealias Model = Favorite

    @Published private(set) var favorites: [Favorite] = []
    @Published private(set) var state = FetchState<[Favorite]>.empty

    private var subscriptions = Set<AnyCancellable>()

    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            state = .error(error)
            canLoadNextPage = false
        }
    }

    private func onReceive(_ batch: Favorite.List) {
        state = .fetched
        favorites = batch.results.sorted { $0.count > $1.count }
    }

    func create(_ object: Favorite, completion: @escaping ((Favorite) -> Void)) {
        var request = URLRequest.request(path: "/api/favorite")
        request.httpMethod = "POST"
        request.addBody(object: object)

        request
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Favorite.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive, receiveValue: completion)
            .store(in: &subscriptions)
    }

    func fetch() {
        state = .fetching
        URLRequest.request(path: "/api/favorite", qs: ["limit": 50])
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Favorite.List.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive, receiveValue: onReceive)
            .store(in: &subscriptions)
    }

    func reload() {
        fetch()
    }

    func start(favorite: Favorite, receiveOutput: @escaping ((Pomodoro) -> Void)) {
        var request = URLRequest.request(path: "/api/favorite/\(favorite.id)/start")
        request.httpMethod = "POST"

        request
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Pomodoro.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive, receiveValue: receiveOutput)
            .store(in: &subscriptions)
    }

    func delete(_ object: Favorite) {
        var request = URLRequest.request(path: "/api/favorite/\(object.id)")
        request.httpMethod = "DELETE"
        request.dataTaskPublisher()
            .map { $0.response }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (failure) in
                    print(failure)
                },
                receiveValue: { (response) in
                    print(response)
                }
            )
            .store(in: &subscriptions)
    }

    func delete(at offset: IndexSet) {
        offset.forEach { (index) in
            delete(favorites[index])
        }
        favorites.remove(atOffsets: offset)
        //        reload()
    }
}
