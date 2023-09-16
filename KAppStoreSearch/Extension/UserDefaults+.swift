//
//  UserDefaults+.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import Foundation

extension UserDefaults {
    /// UserDefaults Key
    enum Key: String {
        /// 최근 검색어 리스트
        case recentSearchTextList = "RECENT_SEARCH_TEXT_LIST"
        /// 테스트용
        case test = "TEST_USER_DEFAULTS_KEY"
    }
    
    /// 아이템 가져오기
    ///
    /// 해당 타입의 배열(옵셔널)을 반환한다.
    func fetch<T: Codable & Equatable>(key: Key) -> [T]? {
        guard let data = data(forKey: key.rawValue) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        
        let decodedData = try? decoder.decode([T].self, from: data)
        
        return decodedData
    }
    
    /// 아이템 저장하기
    ///
    /// 배열의 0번째에 아이템을 저장한다.
    ///
    /// 만약 기존에 존재하는 아이템을 저장한다면, 배열의 0번째로 이동한다. (중복 저장 X)
    func save<T: Codable & Equatable>(_ item: T, key: Key) throws {
        var oldItems: [T] = fetch(key: key) ?? []
        
        oldItems = oldItems.filter { $0 != item }
        
        let newItems = [item] + oldItems
        
        try saveData(newItems, key: key)
    }
    
    /// 아이템 삭제
    ///
    /// 한개의 아이템을 삭제한다
    func remove<T: Codable & Equatable>(_ item: T, key: Key) throws {
        var oldItems: [T] = fetch(key: key) ?? []
        
        oldItems = oldItems.filter { $0 != item }
        
        try saveData(oldItems, key: key)
    }
    
    /// 모든 아이템 삭제
    func removeAll(key: Key) {
        setValue(nil, forKey: key.rawValue)
    }
    
    /// 데이터 저장
    ///
    /// JSON Encoding 후 데이터 저장
    private func saveData<T: Codable & Equatable>(_ items: [T], key: Key) throws {
        let encoder = JSONEncoder()
        
        let encodedData = try encoder.encode(items)
        
        setValue(encodedData, forKey: key.rawValue)
    }
}
