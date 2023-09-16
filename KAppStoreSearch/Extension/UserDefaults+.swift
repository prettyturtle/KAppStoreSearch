//
//  UserDefaults+.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import Foundation

extension UserDefaults {
    enum Key: String {
        case recentSearchTextList = "RECENT_SEARCH_TEXT_LIST"
        case test = "TEST_USER_DEFAULTS_KEY"
    }
    
    func fetch<T: Codable & Equatable>(key: Key) -> [T]? {
        guard let data = data(forKey: key.rawValue) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        
        let decodedData = try? decoder.decode([T].self, from: data)
        
        return decodedData
    }
    
    func save<T: Codable & Equatable>(_ item: T, key: Key) throws {
        var oldItems: [T] = fetch(key: key) ?? []
        
        oldItems = oldItems.filter { $0 != item }
        
        let newItems = [item] + oldItems
        
        let encoder = JSONEncoder()
        
        let encodedData = try encoder.encode(newItems)
        
        setValue(encodedData, forKey: key.rawValue)
    }
}