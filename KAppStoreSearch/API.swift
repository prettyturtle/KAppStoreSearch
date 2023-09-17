//
//  API.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import Foundation

enum API {
    static let host = "https://itunes.apple.com"
    
    enum Path: String {
        case search = "/search"
    }
    
    static func search(keyword: String) -> NetworkRequest<SearchResponse> {
        return NetworkRequest(path: .search, queryItems: ["term": keyword, "country": "KR", "entity": "software"])
    }
}
