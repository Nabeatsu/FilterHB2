//
//  ContentView.swift
//  FilterHB2
//
//  Created by 田辺信之 on 2019/11/07.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import SwiftUI
import SWXMLHash

internal struct TimelineView: View {
    @ObservedObject internal var viewModel: TimelineViewModel

    init(viewModel: TimelineViewModel) {
        viewModel.url = HatenaRSSList.home.url
        self.viewModel = viewModel
    }

    internal var body: some View {
        NavigationView {
            List {
                if viewModel.dataSource.isEmpty {
                    emptySection
                } else {
                    timelineSection
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("記事一覧 ⛅️")
        }
    }

    private var logger = { () -> Void in
        print("hoge")
    }
}

private extension TimelineView {
    var timelineSection: some View {
        Section {
            ForEach(viewModel.dataSource, content: TimelineRow.init)
        }
    }
    var emptySection: some View {
        Text("No results")
            .foregroundColor(.gray)
    }
}

internal struct ContentView_Previews: PreviewProvider {
    internal static var previews: some View {
        TimelineView(viewModel: TimelineViewModel(hatenaRSSFetcher: HatenaRSSFetcher()))
    }
}
