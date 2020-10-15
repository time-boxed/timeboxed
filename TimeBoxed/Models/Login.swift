//
//  Login.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/12.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Foundation

typealias Login = String

extension Login {
    var username: String {
        return components(separatedBy: "@").first!
    }
    var domain: String {
        return components(separatedBy: "@").last!
    }

    func request(for path: String, qs: [String: String] = [:]) -> URLRequest {
        var url = URLComponents()
        url.scheme = "https"
        url.host = domain
        url.path = path
        url.queryItems = qs.map { URLQueryItem(name: $0, value: $1) }

        return URLRequest(url: url.url!)
    }
}

typealias SavedLogins = [Login]

extension SavedLogins: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(SavedLogins.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
