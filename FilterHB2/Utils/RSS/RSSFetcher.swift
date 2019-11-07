//
//  FeedParser.swift
//  FilterHB2
//
//  Created by 田辺信之 on 2019/11/07.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import Foundation

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

    public func parseFeed(url: HatenaRSSList, completionHandler: (([RSSItem]) -> Void)?) {
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
