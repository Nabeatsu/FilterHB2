//
//  RSSError.swift
//  FilterHB2
//
//  Created by 田辺信之 on 2019/11/07.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import Foundation

public enum RSSError: Error {
    case parsing(description: String)
    case network(description: String)
}
