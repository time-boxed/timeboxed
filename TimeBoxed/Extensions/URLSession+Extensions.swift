//
//  URLSession+Extensions.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/05/29.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import Foundation
import os.log

enum HttpMethod: Equatable {
    case get([URLQueryItem])
    case put(Data?)
    case patch(Data?)
    case post(Data?)
    case delete
    case head

    var name: String {
        switch self {
        case .get: return "GET"
        case .put: return "PUT"
        case .post: return "POST"
        case .patch: return "PATCH"
        case .delete: return "DELETE"
        case .head: return "HEAD"
        }
    }
}

extension URLRequest {
    mutating func addBasicAuth(login: Login) {
        addBasicAuth(username: login.username, password: login.password)
    }
    mutating func addBasicAuth(username: String, password: String) {
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    }

    mutating func addBody<T: Encodable>(object: T) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        do {
            httpBody = try encoder.encode(object)
            addValue("application/json", forHTTPHeaderField: "Content-Type")
            addValue("application/json", forHTTPHeaderField: "Accept")
        } catch let error {
            os_log(.error, log: .network, "%s", error.localizedDescription)
        }
    }

    static func request(path: String, login: Login, password: String, qs: [URLQueryItem] = [])
        -> URLRequest
    {
        let request = login.request(authed: path, with: password, qs: qs)
        return request
    }

    func dataTaskPublisher(for session: URLSession = URLSession.shared)
        -> URLSession.DataTaskPublisher
    {
        return session.dataTaskPublisher(for: self)
    }

    static func request(path: String, qs: [URLQueryItem] = []) -> URLRequest {
        // TODO: Use proper environment object
        let userSettings = UserSettings()
        let login = userSettings.current_user ?? "@"
        return login.request(authed: path, qs: qs)
    }

    static func request(path: String, qs: [String: Any]) -> URLRequest {
        return request(path: path, qs: qs.map { URLQueryItem(name: $0, value: "\($1)") })
    }
}

typealias Request<Response> = URLRequest

extension URLSession {
    enum Error: Swift.Error {
        case networking(URLError)
        case decoding(Swift.Error)
    }

    func publisher<Value: Decodable>(
        for request: Request<Value>, using decoder: JSONDecoder = .djangoDecoder
    )
        -> AnyPublisher<Value, Swift.Error>
    {
        os_log(.info, log: .network, "%s", request.debugDescription)

        return dataTaskPublisher(for: request)
            .mapError(Error.networking)
            .map(\.data)
            .decode(type: Value.self, decoder: decoder)
            .mapError(Error.decoding)
            .eraseToAnyPublisher()
    }
}
