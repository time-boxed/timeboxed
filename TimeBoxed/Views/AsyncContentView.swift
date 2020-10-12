//
//  AsyncContentView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/10/12.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//
// https://swiftbysundell.com/articles/handling-loading-states-in-swiftui/

import SwiftUI

enum LoadingState<Value> {
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
}

protocol LoadableObject: ObservableObject {
    associatedtype Output
    var state: LoadingState<Output> { get }
    func load()
}

struct ErrorView: View {
    let error: Error
    let retryHandler: () -> Void
    var body: some View {
        Button(error.localizedDescription, action: retryHandler)
    }
}

struct ReloadButton<Source: LoadableObject>: View {
    @ObservedObject var source: Source
    var body: some View {
        switch source.state {
        case .loading:
            EmptyView()
        default:
            Button("Reload", action: source.load)
        }
    }
}

struct AsyncContentView<Source: LoadableObject, Content: View>: View {
    @ObservedObject var source: Source
    var content: (Source.Output) -> Content

    var body: some View {
        switch source.state {
        case .idle, .loading:
            ProgressView().onAppear(perform: source.load)
        case .failed(let error):
            ErrorView(error: error, retryHandler: source.load)
        case .loaded(let output):
            content(output)
        }
    }

    init(
        source: Source,
        @ViewBuilder content: @escaping (Source.Output) -> Content
    ) {
        self.source = source
        self.content = content
    }
}
