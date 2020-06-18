//
//  Validation.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/18.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//
// Taken from https://newcombe.io/2020/03/05/validation-with-swiftui-combine-part-1/

import Combine
import Foundation
import SwiftUI

enum Validation {
    case success
    case failure(message: String)
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}

typealias ValidationErrorClosure = () -> String

typealias ValidationPublisher = AnyPublisher<Validation, Never>

extension Validation {
    static func nonEmptyValidation(
        for publisher: Published<String>.Publisher,
        errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> ValidationPublisher {
        return publisher.map { value in
            guard value.count > 0 else {
                return .failure(message: errorMessage())
            }
            return .success
        }
        .dropFirst()
        .eraseToAnyPublisher()
    }

    static func matcherValidation(
        for publisher: Published<String>.Publisher,
        withPattern pattern: NSRegularExpression,
        errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> ValidationPublisher {
        return publisher.map { value in
            let matches = pattern.matches(
                in: value, options: .anchored, range: .init(value.startIndex..., in: value))
            switch matches.count {
            case 0:
                return .failure(message: errorMessage())
            default:
                return .success
            }
        }
        .dropFirst()
        .eraseToAnyPublisher()
    }

    static func dateValidation(
        for publisher: Published<Date>.Publisher, afterDate after: Date = .distantPast,
        beforeDate before: Date = .distantFuture,
        errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> ValidationPublisher {
        return publisher.map { date in
            return date > after && date < before ? .success : .failure(message: errorMessage())
        }.eraseToAnyPublisher()
    }
}

extension Published.Publisher where Value == String {

    func nonEmptyValidator(_ errorMessage: @autoclosure @escaping ValidationErrorClosure)
        -> ValidationPublisher
    {
        return Validation.nonEmptyValidation(for: self, errorMessage: errorMessage())
    }

    func matcherValidation(
        _ pattern: String, _ errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> ValidationPublisher {
        return Validation.matcherValidation(
            for: self,
            withPattern: try! NSRegularExpression(pattern: pattern, options: .caseInsensitive),
            errorMessage: errorMessage())
    }

}

extension Published.Publisher where Value == Date {
    func dateValidation(
        afterDate after: Date = .distantPast,
        beforeDate before: Date = .distantFuture,
        errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> ValidationPublisher {
        return Validation.dateValidation(
            for: self, afterDate: after, beforeDate: before, errorMessage: errorMessage())
    }
}
