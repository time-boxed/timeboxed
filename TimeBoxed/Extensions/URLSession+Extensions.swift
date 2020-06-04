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
}

extension URLSession {
    func dataTaskPublisher(path: String, login: String, password: String)
        -> URLSession.DataTaskPublisher
    {
        let parts = login.components(separatedBy: "@")

        var url = URLComponents()
        url.scheme = "https"
        url.host = parts[1]
        url.path = path

        var request = URLRequest(url: url.url!)
        request.addBasicAuth(username: parts[0], password: password)

        os_log(.debug, "Querying %{public}s for %{public}s", url.string!, parts[0])

        return dataTaskPublisher(for: request)
    }
    func dataTaskPublisher(path: String) -> URLSession.DataTaskPublisher {
        let userSettings = UserSettings.instance
        let login = userSettings.current_user ?? "@"
        let password = Settings.keychain.string(for: login) ?? ""

        return dataTaskPublisher(path: path, login: login, password: password)
    }
}
