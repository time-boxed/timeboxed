//
//  Array+Extensions.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/29.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Foundation

extension Array where Element == Pomodoro {
    func groupByProject() -> [Project: [Pomodoro]] {
        return Dictionary(
            grouping: self,
            by: { $0.project ?? ReportByProject.defaultProject }
        )
    }
}

// From https://www.swiftbysundell.com/articles/reducers-in-swift/
extension Sequence {
    func sum<T: Numeric>(for keyPath: KeyPath<Element, T>) -> T {
        return reduce(0) { sum, element in
            sum + element[keyPath: keyPath]
        }
    }
}
