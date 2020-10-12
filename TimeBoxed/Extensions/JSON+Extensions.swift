//
//  JSON+Extensions.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/12.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static var djangoDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
