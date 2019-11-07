//
//  RSSFetchable.swift
//  FilterHB2
//
//  Created by 田辺信之 on 2019/11/07.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import Foundation
import Combine

protocol RSSFetchable {
    func fetchQiita(tag: String) -> AnyPublisher<[RSSItem], RSSError>
}
