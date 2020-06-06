//
//  PreviewData.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/06.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Foundation
import SwiftUI

#if DEBUG

    final class PreviewData {
        static var pomodoro = Pomodoro(
            id: 0,
            title: "Preview Title",
            start: Date(),
            end: Date(),
            category: "Preview Category",
            memo: "Some memo"
        )

        static var favorite = Favorite(
            id: 0,
            title: "Preview Favorite",
            duration: 60,
            memo: "Preview Memo",
            icon: nil,
            html_link: URL(string: "https://example.com")!,
            url: nil,
            count: 1
        )

        static var device = PreviewDevice(rawValue: "iPhone SE")
    }

#endif
