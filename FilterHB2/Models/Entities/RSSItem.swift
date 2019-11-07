//
//  File.swift
//  FilterHB2
//
//  Created by 田辺信之 on 2019/11/08.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import Foundation

/// RSSから取得した値を受けとる
public struct RSSItem {
    internal var title: String
    internal var description: String
    internal var pubDate: String
    internal var url: String
    internal var bookmarkCount: String
    internal var imageUrl: String
}
