//
//  OSLog+Extensions.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/11/28.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    static var pomodoro = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "pomodoro")
    static var project = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "project")
    static var network = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "network")
    static var login = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "login")
}
