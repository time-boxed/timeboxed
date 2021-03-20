//
//  Login.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/12.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Foundation
import KeychainAccess

typealias Login = String

private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)

extension Login {
    var username: String {
        return components(separatedBy: "@").first!
    }
    var domain: String {
        return components(separatedBy: "@").last!
    }

    //let password = Settings.keychain.string(for: self) ?? ""
    var password: String {
        set { try? keychain.set(newValue, key: self) }
        get { keychain.string(for: self) ?? "" }
    }

    func request(path: String, method: HttpMethod) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = domain
        components.path = path

        switch method {
        case .get(let qs):
            components.queryItems = qs
        default:
            break
        }

        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.name

        switch method {
        case .post(let data), .put(let data):
            request.httpBody = data
        default:
            break
        }

        return request
    }

    func request<T: Encodable>(path: String, post: T, using encoder: JSONEncoder = .djangoEncoder)
        -> URLRequest
    {
        let data = try! encoder.encode(post)
        var req = request(path: path, method: .post(data))
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        return req
    }

    func request<T: Encodable>(path: String, put: T, using encoder: JSONEncoder = .djangoEncoder)
        -> URLRequest
    {
        let data = try! encoder.encode(put)
        var req = request(path: path, method: .put(data))
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        return req
    }

    func request<T: Encodable>(path: String, patch: T, using encoder: JSONEncoder = .djangoEncoder)
        -> URLRequest
    {
        let data = try! encoder.encode(patch)
        var req = request(path: path, method: .patch(data))
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        return req
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
        //        request.addBasicAuth(username: username, password: password)
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
