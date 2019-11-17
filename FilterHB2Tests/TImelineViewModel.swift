//
//  TImelineViewModel.swift
//  FilterHB2
//
//  Created by tanabe.nobuyuki on 2019/11/17.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import Foundation
import  SwiftUI
import Combine


public class TimelineViewModel: ObservableObject, Identifiable {
    @Published var url: URL? = nil
    @Published var dataSource: [TimelineRowViewModel] = []
    private let hatenaRSSFetcher: RSSFetchable
    private var disposables = Set<AnyCancellable>()
    
    init(hatenaRSSFetcher: RSSFetchable,
         scheduler: DispatchQueue = DispatchQueue(label: "TimelineViewModel")) {
        self.hatenaRSSFetcher = hatenaRSSFetcher
        
        _ = $url
            .dropFirst(1)
            .debounce(for: .seconds(0.5), scheduler: scheduler)
        .sink(receiveValue: fetchRSS(from:))
    }
    
    func fetchRSS(from url: URL?) {
        hatenaRSSFetcher.fetchRSS(from: url)
            .map { response in
                response.map(TimelineRowViewModel.init)
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] value in
            guard let self = self else { return }
            switch value {
            case .failure(_):
                self.dataSource = []
            case .finished:
                break
            }
            }, receiveValue: { [weak self] rowViewModel in
                guard let self = self else { return }
                self.dataSource = rowViewModel
        })
            .store(in: &disposables)
    }
}
