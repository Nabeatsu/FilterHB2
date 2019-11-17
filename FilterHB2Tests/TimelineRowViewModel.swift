//
//  TimelineRowViewModel.swift
//  FilterHB2
//
//  Created by tanabe.nobuyuki on 2019/11/17.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import Foundation
import SwiftUI

struct TimelineRowViewModel: Identifiable {
    internal var id: String
    internal var title: String
    internal var description: String
    internal var pubDate: String
    internal var url: URL
    internal var bookmarkCount: Int
    internal var imageUrl: String
    
    init(item: RSSItem) {
        self.id = item.url
        self.title = item.title
        self.description = item.description
        self.pubDate = item.pubDate
        self.url = URL(string: item.url)!
        self.bookmarkCount = Int(item.bookmarkCount) ?? 0
        self.imageUrl = item.imageUrl
    }
}
