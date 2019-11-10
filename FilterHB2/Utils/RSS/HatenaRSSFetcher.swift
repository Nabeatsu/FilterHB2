//
//  FeedParser.swift
//  FilterHB2
//
//  Created by 田辺信之 on 2019/11/07.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import Combine
import Foundation
import SWXMLHash

/// download xml from a server,
/// parse xml to foundation objects
/// call baxhck
public struct HatenaRSSFetcher: RSSFetchable {
    public func fetchRSS(from rssinfo: RSSInfo) -> AnyPublisher<[RSSItem], RSSError> {
        guard let url = rssinfo.url else {
            let error = RSSError.parsing(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        let session = URLSession.shared
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                .network(description: error.localizedDescription)
            }
        .flatMap(maxPublishers: .max(1)) { pair in
            self.decode(pair.data)
        }
        .eraseToAnyPublisher()
    }

    private func decode(_ data: Data) -> AnyPublisher<[RSSItem], RSSError> {
        let xml = SWXMLHash.parse(data)
        return Just(xml)
            .decode(xml: xml)
            .mapError { error in
                .parsing(description: error.localizedDescription)
            }
        .eraseToAnyPublisher()
    }
}
