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

final class PomodoroStore: ObservableObject {
    static var shared = PomodoroStore()
    private init() {

    }

    @Published private(set) var pomodoros = [Pomodoro]()
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
            .assign(to: \.pomodoros, on: self)
    }

    func update(id: Int, end: Date) {
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
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { (error) in
                print(error)
            }) { (pomodoro) in
                print(pomodoro)
                self.fetch()
            }
    }
}
