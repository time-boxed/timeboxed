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
    var category: String
    var memo: String?
    var project: String?
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
}

typealias PomodoroCompletion = ((Pomodoro) -> Void)

final class PomodoroStore: API {
    typealias Model = Pomodoro

    private var subscriptions = Set<AnyCancellable>()

    @Published private(set) var pomodoros: [Pomodoro] = []
    @Published private(set) var state = FetchState<[Pomodoro]>.empty
    @Published private(set) var currentPomodoro: Pomodoro?

    // Scroll
    private var offset = "0"
    var canLoadNextPage = true

    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            state = .error(error)
            canLoadNextPage = false
        }
    }

    private func onReceive(_ batch: Pomodoro.List) {
        pomodoros += batch.results.sorted { $0.start > $1.start }
        currentPomodoro = pomodoros.first
        state = .fetched

        canLoadNextPage = batch.next != nil
        guard canLoadNextPage else { return }

        if let next = URLComponents(string: batch.next ?? "") {
            next.queryItems?.forEach({ (queryItem) in
                if queryItem.name == "offset" {
                    self.offset = queryItem.value!
                }
            })
        } else {
            canLoadNextPage = false
        }
    }

    func reload() {
        pomodoros = []
        offset = "0"
        canLoadNextPage = true

        fetch()
    }

    func fetch() {
        guard canLoadNextPage else { return }
        state = .fetching

        URLRequest.request(path: "/api/pomodoro", qs: ["offset": offset])
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Pomodoro.List.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive, receiveValue: onReceive)
            .store(in: &subscriptions)
    }

    func create(_ object: Pomodoro, completion: @escaping ((Pomodoro) -> Void)) {
        var request = URLRequest.request(path: "/api/pomodoro")
        request.httpMethod = "POST"
        request.addBody(object: object)

        request
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Pomodoro.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive, receiveValue: completion)
            .store(in: &subscriptions)
    }

    func update(id: Int, end: Date, completion: @escaping ((Pomodoro) -> Void)) {
        let update = Pomodoro.DateRequest(end: end)
        var request = URLRequest.request(path: "/api/pomodoro/\(id)")
        request.httpMethod = "PATCH"
        request.addBody(object: update)

        request
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Pomodoro.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive, receiveValue: completion)
            .store(in: &subscriptions)
    }

    func delete(_ pomodoro: Pomodoro) {
        var request = URLRequest.request(path: "/api/pomodoro/\(pomodoro.id)")
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
            delete(pomodoros[index])
        }
        pomodoros.remove(atOffsets: offset)
    }
}
