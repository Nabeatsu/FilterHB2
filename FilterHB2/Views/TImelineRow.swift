//
//  TimelineRow.swift
//  FilterHB2
//
//  Created by tanabe.nobuyuki on 2019/11/18.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import Foundation
import SwiftUI

internal struct TimelineRow: View {
    internal let viewModel: TimelineRowViewModel

    init(viewModel: TimelineRowViewModel) {
        self.viewModel = viewModel
    }

    internal var body: some View {
        VStack(alignment: .leading) {
            Text("\(viewModel.title)")
            Text("\(viewModel.url)")
        }
    }
}

internal struct TimelineRow_Previews: PreviewProvider {
    internal static var previews: some View {
        TimelineRow(
            viewModel: TimelineRowViewModel(
                item: RSSItem(
                    title: "google",
                    description: "lsdkfjsd;lkfj;asldfjl;dksfj;lkadjfkljasd;lkfjlak;fjkajdf;lkasjf;aljflk;sjdf;j",
                    pubDate: "12/21",
                    url: "https://google.co.jp",
                    bookmarkCount: "lksdfjlksdfjlksdjf",
                    imageUrl: "https://google.co.jp"
                )
            )
        )
    }
}
