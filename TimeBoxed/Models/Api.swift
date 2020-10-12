//
//  Api.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/07/02.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import Foundation

protocol API: ObservableObject {
    associatedtype Model: Codable, Identifiable

    var canLoadNextPage: Bool { get set }

    func reload()
    func fetch()
    func create(_ object: Model, completion: @escaping ((Model) -> Void))
    func delete(at offset: IndexSet)
    func delete(_ object: Model)
    func onReceive(_ completion: Subscribers.Completion<Error>)
}

extension API {
    internal var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
