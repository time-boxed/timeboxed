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

final class PomodoroStore: ObservableObject {
    static var shared = PomodoroStore()
    private var subscriptions = Set<AnyCancellable>()

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    private init() {}

    @Published private(set) var pomodoros = [Pomodoro]()
    @Published private(set) var currentPomodoro: Pomodoro?

    // Scroll
    private var offset = "0"
    var canLoadNextPage = true

    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
            canLoadNextPage = false
        }
    }

    private func onReceive(_ batch: Pomodoro.List) {
        pomodoros += batch.results
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

    func fetch() {
        URLRequest.request(path: "/api/pomodoro", qs: ["offset": offset])
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Pomodoro.List.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive, receiveValue: onReceive)
            .store(in: &subscriptions)
    }

    func create(_ pomodoro: Pomodoro, completion: @escaping PomodoroCompletion = { _ in }) {
        var request = URLRequest.request(path: "/api/pomodoro")
        request.httpMethod = "POST"
        request.addBody(object: pomodoro)

        request
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Pomodoro.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (error) in
                    print(error)
                },
                receiveValue: { (pomodoro) in
                    self.currentPomodoro = pomodoro
                    completion(pomodoro)
                }
            )
            .store(in: &subscriptions)
    }

    func update(id: Int, end: Date, completion: @escaping PomodoroCompletion = { _ in }) {
        let update = Pomodoro.DateRequest(end: end)
        var request = URLRequest.request(path: "/api/pomodoro/\(id)")
        request.httpMethod = "PATCH"
        request.addBody(object: update)

        request
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Pomodoro.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (error) in
                    print(error)
                },
                receiveValue: { (pomodoro) in
                    self.currentPomodoro = pomodoro
                    completion(pomodoro)
                }
            )
            .store(in: &subscriptions)
    }
}
