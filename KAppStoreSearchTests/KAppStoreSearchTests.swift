//
//  KAppStoreSearchTests.swift
//  KAppStoreSearchTests
//
//  Created by yc on 2023/09/16.
//

import XCTest

final class KAppStoreSearchTests: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func test_UserDefaults_저장_가져오기() {
        let old: [String] = UserDefaults.standard.fetch(key: .test) ?? []
        
        let newItem = "NEW ITEM"
        
        try? UserDefaults.standard.save(newItem, key: .test)
        
        let new: [String] = UserDefaults.standard.fetch(key: .test) ?? []
        
        XCTAssertEqual([newItem] + old, new)
    }
}
