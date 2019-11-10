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

public struct RSSItemsPublsher: Publisher {
    public let elem: XMLIndexer

    public func receive<S>(subscriber: S) where S: Subscriber, RSSItemsPublsher.Failure == S.Failure, RSSItemsPublsher.Output == S.Input {
        let results = elem.all.map { RSSItem.make(from: $0) }
        var items = [RSSItem]()
        var error: RSSError?
        _ = results.map { result in
            switch result {
            case .success(let item):
                items.append(item)

            case .failure(let rssError):
                error = rssError
            }
        }
        if let error = error {
            subscriber.receive(completion: .failure(error))
        }
        _ = subscriber.receive(items)
        subscriber.receive(completion: .finished)
    }

    public typealias Output = [RSSItem]
    public typealias Failure = RSSError
}

public extension Publisher {
    /// XMLIndexerからPublisherを生成するための function
    /// - Parameter xml: はてなRSS対応のXML。異なるとRSSError.convertの可能性
    func decode(xml: XMLIndexer) -> RSSItemsPublsher {
        return RSSItemsPublsher(elem: xml)
    }
}

/// RSSから取得した値を受けとる
public struct RSSItem {
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

        guard let currentImageUrl = xml["hatena:imageurl"].element?.text else {
            return .failure(.converting(description: "XML Element Error: Incorrect key [\"hatena:imageurl\"]"))
        }

        return .success(RSSItem(
            title: title,
            description: description,
            pubDate: pubDate,
            url: currentUrl,
            bookmarkCount: currentbookmarkCount,
            imageUrl: currentImageUrl
        ))
    }
}
