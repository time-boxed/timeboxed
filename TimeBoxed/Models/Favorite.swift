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

    struct List: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Favorite]
    }
}

typealias FavoriteCompletion = ((Favorite) -> Void)

final class FavoriteStore: ObservableObject {
    @Published private(set) var favorites = [Favorite]()
    private var subscriptions = Set<AnyCancellable>()

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }

    private func onReceive(_ batch: Favorite.List) {
        favorites = batch.results.sorted { $0.count > $1.count }
    }

    func create(_ favorite: Favorite, completion: @escaping FavoriteCompletion) {
        var request = URLRequest.request(path: "/api/favorite")
        request.httpMethod = "POST"
        request.addBody(object: favorite)

        request
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Favorite.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive, receiveValue: completion)
            .store(in: &subscriptions)
    }

    func fetch() {
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

    func delete(favorite: Favorite) {
        var request = URLRequest.request(path: "/api/favorite/\(favorite.id)")
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
            delete(favorite: favorites[index])
        }
        favorites.remove(atOffsets: offset)
        //        reload()
    }
}
