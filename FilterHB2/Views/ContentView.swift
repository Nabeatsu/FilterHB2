//
//  ContentView.swift
//  FilterHB2
//
//  Created by 田辺信之 on 2019/11/07.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import SwiftUI
import SWXMLHash

internal struct ContentView: View {
    internal var body: some View {
        Text("Hello, World!").onAppear(perform: logger)
    }

    private var logger = { () -> Void in
        print("hoge")
        //        let xml = SWXMLHash.parse(TestXML)
        //        let text = xml["rdf:RDF"]["item"][0]["title"].element?.text
        //        let texts = xml["rdf:RDF"]["item"].all.map { elem in
        //            elem["title"].element?.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //        }
        //        print(texts)

        //        let parser = HatenaRSSFetcher()
        //        parser.parseFeed(url: .home, completionHandler: { _ in
        //        })
    }
}

internal struct ContentView_Previews: PreviewProvider {
    internal static var previews: some View {
        ContentView()
    }
}
