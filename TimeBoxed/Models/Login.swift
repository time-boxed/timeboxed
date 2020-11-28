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

    func request(for path: String, qs: [URLQueryItem]) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = domain
        components.path = path
        components.queryItems = qs

        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }

        return URLRequest(url: url)
    }

    func request(authed path: String, with password: String, qs: [URLQueryItem]) -> URLRequest {
        var request = self.request(for: path, qs: qs)
        request.addBasicAuth(username: username, password: password)
        return request
    }

    func request(authed path: String, qs: [URLQueryItem]) -> URLRequest {
        let password = Settings.keychain.string(for: self) ?? ""
        return self.request(authed: path, with: password, qs: qs)
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
