//
//  RSSInfo.swift
//  FilterHB2
//
//  Created by tanabe.nobuyuki on 2019/11/17.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import Foundation

/// RSSFetchableの引数で使用。このprotocolに準拠することは取得先のRSSに関する情報を保持することを表す。
public protocol RSSInfo {
    /// Title取得
    var title: String { get }
    /// RSSのURLを取り出すプロパティ
    var url: URL? { get }
}
