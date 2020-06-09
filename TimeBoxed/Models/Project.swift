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

    struct List: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Project]
    }
}

final class ProjectStore: ObservableObject {
    static var shared = ProjectStore()

    @Published private(set) var projects = [Project]()
    private var cancellable: AnyCancellable?

    func fetch() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        cancellable = URLRequest.request(path: "/api/project")
            .dataTaskPublisher()
            .map { $0.data }
            .decode(type: Project.List.self, decoder: decoder)
            .map(\.results)
            .print()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.projects, on: self)
    }
}
