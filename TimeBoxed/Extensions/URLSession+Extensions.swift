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

extension URLComponents {
    mutating func addQuery(qs: [String: Any] = [:]) {
        queryItems = qs.map { (key, value) in
            URLQueryItem(name: key, value: "\(value)")
        }
    }
}

extension URLRequest {
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
            //            addValue("application/json", forHTTPHeaderField: "Accept")
        } catch let error {
            print(error)
        }
    }

    static func request(path: String, login: Login, password: String, qs: [String: Any])
        -> URLRequest
    {
        var url = URLComponents()
        url.scheme = "https"
        url.host = login.domain
        url.path = path
        url.addQuery(qs: qs)

        var request = URLRequest(url: url.url!)
        request.addBasicAuth(username: login.username, password: password)
        os_log(.debug, "%{public}s %{public}s for %{public}s",request.httpMethod!, request.url!.absoluteString, login.username )
        return request
    }

    func dataTaskPublisher(for session: URLSession = URLSession.shared)
        -> URLSession.DataTaskPublisher
    {
        return session.dataTaskPublisher(for: self)
    }

    static func request(path: String, qs: [String: Any] = [:]) -> URLRequest {
        // TODO: Use proper environment object
        let userSettings = UserSettings()
        let login = userSettings.current_user ?? "@"
        let password = Settings.keychain.string(for: login) ?? ""

        return request(path: path, login: login, password: password, qs: qs)
    }

    init(login: Login, path: String, qs: [String: String] = [:]) {
        var url = URLComponents()
        url.scheme = "https"
        url.host = login.domain
        url.path = path
        url.queryItems = qs.map { URLQueryItem(name: $0, value: $1) }
        self.init(url: url.url!)
    }
}
