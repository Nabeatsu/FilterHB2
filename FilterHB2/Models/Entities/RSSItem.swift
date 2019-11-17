//
//  File.swift
//  FilterHB2
//
//  Created by 田辺信之 on 2019/11/08.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import Combine
import Foundation
import SWXMLHash

/// RSSから取得した値を受けとる
public struct RSSItem: Decodable {
    internal var title: String
    internal var description: String
    internal var pubDate: String
    internal var url: String
    internal var bookmarkCount: String
    internal var imageUrl: String

    /// XMLIndexerからRSSItemを生成する method
    /// - Parameter xml: はてなRSS対応のXML。異なるとRSSError.convertの可能性
    public static func make(from xml: XMLIndexer) -> Result<RSSItem, RSSError> {
        guard let title = xml["title"].element?.text else {
            return .failure(.converting(description: "XML Element Error: Incorrect key [\"title\"]"))
        }

        guard let description = xml["description"].element?.text else {
            return .failure(.converting(description: "XML Element Error: Incorrect key [\"description\"]"))
        }

        guard let pubDate = xml["dc:date"].element?.text else {
            return .failure(.converting(description: "XML Element Error: Incorrect key [\"dc:date\"]"))
        }

        guard let currentUrl = xml["link"].element?.text else {
            return .failure(.converting(description: "XML Element Error: Incorrect key [\"link\"]"))
        }

        guard let currentbookmarkCount = xml["hatena:bookmarkcount"].element?.text else {
            return .failure(.converting(description: "XML Element Error: Incorrect key [\"hatena:bookmarkcount\"]"))
        }

        var imageUrl = ""
        if let currentImageUrl = xml["hatena:imageurl"].element?.text {
            imageUrl = currentImageUrl
        }

        return .success(RSSItem(
            title: title,
            description: description,
            pubDate: pubDate,
            url: currentUrl,
            bookmarkCount: currentbookmarkCount,
            imageUrl: imageUrl
        ))
    }
}
