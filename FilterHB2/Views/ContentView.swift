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
    }
}

internal struct ContentView_Previews: PreviewProvider {
    internal static var previews: some View {
        ContentView()
    }
}
