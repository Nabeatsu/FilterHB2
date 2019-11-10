//
//  HatenaRSSList.swift
//  FilterHB2
//
//  Created by 田辺信之 on 2019/11/08.
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

public enum HatenaRSSList: String, RSSInfo {
    case home = "http://b.hatena.ne.jp/hotentry.rss"
    case technology = "http://b.hatena.ne.jp/hotentry/it.rss"
    case study = "http://b.hatena.ne.jp/hotentry/knowledge.rss"
    case social = "http://b.hatena.ne.jp/hotentry/social.rss"
    case economics = "http://b.hatena.ne.jp/hotentry/economics.rss"
    case life = "http://b.hatena.ne.jp/hotentry/life.rss"
    case fun = "http://b.hatena.ne.jp/hotentry/fun.rss"
    case entertainment = "http://b.hatena.ne.jp/hotentry/entertainment.rss"
    case game = "http://b.hatena.ne.jp/hotentry/game.rss"
    case user = "http://b.hatena.ne.jp/yuuta-iwata/bookmark.rss?of=40&14023238743"

    public var title: String {
        switch self {
        case .home:
            return "総合"
        case .technology:
            return "テクノロジー"
        case .study:
            return "学び"
        case .social:
            return "社会"
        case .economics:
            return "政治経済"
        case .life:
            return "生活"
        case .fun:
            return "おもしろ"
        case .entertainment:
            return "エンタメ"
        case .game:
            return "アニメとゲーム"
        case .user:
            return "ユーザー情報"
        }
    }

    public var url: URL? { URL(string: self.rawValue) }
}
