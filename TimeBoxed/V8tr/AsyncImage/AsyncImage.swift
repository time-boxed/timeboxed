//
//  AsyncImage.swift
//  AsyncImage
//
//  Created by Vadym Bulavin on 2/13/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
// https://github.com/V8tr/AsyncImage

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    private let configuration: (Image) -> Image

    init(
        url: URL, cache: ImageCache? = nil, placeholder: Placeholder? = nil,
        configuration: @escaping (Image) -> Image = { $0 }
    ) {
        loader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
        self.configuration = configuration
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }

    private var image: some View {
        Group {
            if loader.image != nil {
                configuration(Image(uiImage: loader.image!))
            } else {
                placeholder
            }
        }
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var data = URL(string: "https://www.google.com/favicon.ico")!
    static var previews: some View {
        AsyncImage(url: data, placeholder: Text("Loading"))
            .previewLayout(.fixed(width: 44, height: 44))
    }
}
