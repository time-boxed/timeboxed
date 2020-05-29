//
//  Base.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/29.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import Foundation

protocol API {
    static func request(path: String) -> URLSession.DataTaskPublisher
}

extension API {
    static func request(path: String) -> URLSession.DataTaskPublisher {
        var request = URLComponents()
        let username = Settings.defaults.string(forKey: .currentUser)!
        let parts = username.components(separatedBy: "@")

        request.host = parts[1]
        request.scheme = "https"
        request.host = parts[1]
        request.path = path

        request.user = parts[0]
        request.password = Settings.keychain.string(for: username)

        return URLSession.shared.dataTaskPublisher(for: request.url!)
    }
}
