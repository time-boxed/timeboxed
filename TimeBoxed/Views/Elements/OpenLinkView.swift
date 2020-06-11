//
//  OpenLinkView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/11.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct OpenLinkView: View {
    var url: URL

    var body: some View {
        NavigationLink(destination: EmptyView()) {
            Text(url.absoluteString)
        }.onTapGesture {
            UIApplication.shared.open(self.url, options: [:], completionHandler: nil)
        }
    }
}

struct OpenLinkView_Previews: PreviewProvider {
    static var previews: some View {
        OpenLinkView(url: URL(string: "https://example.com")!)
    }
}
