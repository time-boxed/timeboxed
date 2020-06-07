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

    private init() {}

    @Published private(set) var pomodoros = [Pomodoro]()
    @Published private(set) var currentPomodoro: Pomodoro?

    private var cancellable: AnyCancellable?

    func fetch() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        cancellable = URLRequest.request(path: "/api/pomodoro")
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Pomodoro.List.self, decoder: decoder)
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .sink(
                receiveCompletion: { (error) in
                    print(error)
                },
                receiveValue: { (newPomodoros) in
                    self.pomodoros = newPomodoros
                    self.currentPomodoro = newPomodoros.first
                })
    }

    func create(_ pomodoro: Pomodoro, completion: @escaping PomodoroCompletion = { _ in }) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        var request = URLRequest.request(path: "/api/pomodoro")
        request.httpMethod = "POST"
        request.addBody(object: pomodoro)

        cancellable =
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
                })
    }

    func update(id: Int, end: Date, completion: @escaping PomodoroCompletion = { _ in }) {
        let update = Pomodoro.DateRequest(end: end)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        var request = URLRequest.request(path: "/api/pomodoro/\(id)")
        request.httpMethod = "PATCH"
        request.addBody(object: update)

        cancellable =
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
                })
    }
}
