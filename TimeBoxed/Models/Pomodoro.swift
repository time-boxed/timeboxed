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
    var memo: String = ""
    var project: Project?
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
    var duration: TimeInterval {
        return end.distance(to: start)
    }
}
