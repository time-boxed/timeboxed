//
//  Project.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/06.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

struct Project: Codable, Identifiable {
    let id: String
    let name: String
    let html_link: URL
    let url: URL?
    let color: Color
    let active: Bool
    let memo: String

    struct List: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Project]
    }
}

final class ProjectStore: ObservableObject {
    static var shared = ProjectStore()

    @Published private(set) var projects: [Project] = []
    @Published private(set) var state = FetchState<[Project]>.empty

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
            state = .error(error)
        }
    }

    private func onReceive(_ batch: Project.List) {
        state = .fetched
        projects = batch.results
    }

    func fetch() {
        state = .fetching
        URLRequest.request(path: "/api/project", qs: ["limit": 50])
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Project.List.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive, receiveValue: onReceive)
            .store(in: &subscriptions)
    }
}
