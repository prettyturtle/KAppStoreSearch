//
//  URLComponents+.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/17.
//

import Foundation

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
