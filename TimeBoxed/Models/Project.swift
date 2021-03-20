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

struct Project: Codable, Identifiable, Equatable, Hashable {
    let id: String
    var name: String
    let html_link: URL
    var url: URL?
    var color: Color
    var active: Bool
    var memo: String
    var duration: TimeInterval

    struct List: Codable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [Project]
    }
}
