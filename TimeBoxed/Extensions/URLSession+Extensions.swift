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
