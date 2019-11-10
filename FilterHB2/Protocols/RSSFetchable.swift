//
//  RSSFetchable.swift
//  FilterHB2
//
//  Created by 田辺信之 on 2019/11/07.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import Combine
import Foundation

/// RSSをfetchするためにconformするprotocol
public protocol RSSFetchable {
    /// 引数に渡された情報を元にRSSからXMLを取得してパースし、RSSItemの配列にして返す関数
    /// - Parameter rssinfo: 取得するRSSに関する情報を保持したRSSInfo protocolに準拠する値
    func fetchRSS(from rssinfo: RSSInfo) -> AnyPublisher<[RSSItem], RSSError>
}
