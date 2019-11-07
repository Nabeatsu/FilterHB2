//
//  FeedParser.swift
//  FilterHB2
//
//  Created by 田辺信之 on 2019/11/07.
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

public enum UrlList: String {
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

    public func getTitle() -> String {
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
}
// download xml from a server,
// parse xml to foundation objects
// call baxhck
public class RSSFetcher: NSObject, XMLParserDelegate {
    //""
    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentUrl: String = "" {
        didSet {
            currentUrl = currentUrl.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentBookmarkCount: String = "" {
        didSet {
            currentBookmarkCount = currentBookmarkCount.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentImageUrl: String = "" {
        didSet {
            currentImageUrl = currentImageUrl.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var parserCompletionHandler: (([RSSItem]) -> Void)?

    public func parseFeed(url: UrlList, completionHandler: (([RSSItem]) -> Void)?) {
        self.parserCompletionHandler = completionHandler

        let request = URLRequest(url: URL(string: url.rawValue)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) {data, _, error in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                return
            }
            // parse our xml data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }

    public func parseFeed(urlString: String, completionHandler: (([RSSItem]) -> Void)?) {
        self.parserCompletionHandler = completionHandler

        let request = URLRequest(url: URL(string: urlString)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) {data, _, error in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                return
            }
            // parse our xml data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }

    // MARK: XML Parser Delegate
    public func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]
    ) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentUrl = ""
            currentImageUrl = ""
            currentBookmarkCount = ""
        }
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "description": currentDescription += string
        case "dc:date" : currentPubDate += string
        case "link" : currentUrl += string
        case "hatena:bookmarkcount" : currentBookmarkCount += string
        case "hatena:imageurl": currentImageUrl += string
        default: break
        }
    }

    public func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        if elementName == "item" {
            let rssItem = RSSItem(
                title: currentTitle,
                description: currentDescription,
                pubDate: currentPubDate,
                url: currentUrl,
                bookmarkCount: currentBookmarkCount,
                imageUrl: currentImageUrl
            )
            self.rssItems.append(rssItem)
        }
    }

    public func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }

    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
