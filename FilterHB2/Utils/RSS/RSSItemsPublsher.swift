//
//  RSSItemsPublsher.swift
//  FilterHB2
//
//  Created by tanabe.nobuyuki on 2019/11/17.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import Combine
import Foundation
import SWXMLHash

public struct RSSItemsPublsher: Publisher {
    public let elem: XMLIndexer

    public func receive<S>(subscriber: S) where S: Subscriber, RSSItemsPublsher.Failure == S.Failure, RSSItemsPublsher.Output == S.Input {
        let results = elem["rdf:RDF"]["item"].all.map { RSSItem.make(from: $0) }
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
