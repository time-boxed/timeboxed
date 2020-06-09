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

    static func request(path: String, login: String, password: String) -> URLRequest {
        let parts = login.components(separatedBy: "@")

        var url = URLComponents()
        url.scheme = "https"
        url.host = parts[1]
        url.path = path

        var request = URLRequest(url: url.url!)
        request.addBasicAuth(username: parts[0], password: password)
        os_log(.debug, "Querying %{public}s for %{public}s", url.string!, parts[0])
        return request
    }

    func dataTaskPublisher(for session: URLSession = URLSession.shared)
        -> URLSession.DataTaskPublisher
    {
        return session.dataTaskPublisher(for: self)
    }

    static func request(path: String) -> URLRequest {
        // TODO: Use proper environment object
        let userSettings = UserSettings()
        let login = userSettings.current_user ?? "@"
        let password = Settings.keychain.string(for: login) ?? ""

        return request(path: path, login: login, password: password)
    }
}
