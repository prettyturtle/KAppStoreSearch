//
//  KAppStoreSearchTests.swift
//  KAppStoreSearchTests
//
//  Created by yc on 2023/09/16.
//

import XCTest

final class KAppStoreSearchTests: XCTestCase {
    
    override func setUpWithError() throws {
        let mockItem = ["TEST"]
        let encodedMockItem = try! JSONEncoder().encode(mockItem)
        UserDefaults.standard.setValue(encodedMockItem, forKey: UserDefaults.Key.test.rawValue) // Set UserDefaults Test Mock Data
    }
    
    override func tearDownWithError() throws {
    }
    
    func test_UserDefaults_아이템_가져오기() {
        let items: [String]? = UserDefaults.standard.fetch(key: .test)
        
        XCTAssertEqual(items, ["TEST"])
    }
    
    func test_UserDefaults_아이템_저장() {
        let old: [String] = UserDefaults.standard.fetch(key: .test) ?? []
        
        let newItem = "NEW ITEM"
        
        try? UserDefaults.standard.save(newItem, key: .test)
        
        let new: [String] = UserDefaults.standard.fetch(key: .test) ?? []
        
        XCTAssertEqual([newItem] + old, new)
    }
    
    func test_UserDefaults_중복_아이템_저장() {
        let newItem1 = "NEW ITEM"
        
        try? UserDefaults.standard.save(newItem1, key: .test)
        
        let newItem2 = "TEST"
        
        try? UserDefaults.standard.save(newItem2, key: .test)
        
        let new: [String] = UserDefaults.standard.fetch(key: .test) ?? []
        
        XCTAssertEqual(["TEST", "NEW ITEM"], new)
    }
    
    func test_UserDefaults_모든_아이템_삭제() {
        UserDefaults.standard.removeAll(key: .test)
        
        let items: [String]? = UserDefaults.standard.fetch(key: .test)
        
        XCTAssertNil(items)
    }
    
    func test_UserDefaults_아이템_한개_삭제() {
        try? UserDefaults.standard.remove("TEST", key: .test)
        
        let items: [String]? = UserDefaults.standard.fetch(key: .test)
        
        XCTAssertEqual(items, [])
    }
    
    func test_단위_변환_10만_이상() {
        let nums = [100_000, 123_456, 1_234_567, 999_999]
        
        let expect = ["10만", "12만", "123만", "99만"]
        let result = nums.map { Double($0).convertToUnitString }
        
        XCTAssertEqual(result, expect)
    }
    func test_단위_변환_10만_미만_1만_이상() {
        let nums = [99_999, 10_000, 12_345]
        let expect = ["9.9만", "1만", "1.2만"]
        let result = nums.map { Double($0).convertToUnitString }
        
        XCTAssertEqual(result, expect)
    }
    func test_단위_변환_1만_미만_1천_이상() {
        let nums = [9_999, 1_000, 1_234]
        let expect = ["9.9천", "1천", "1.2천"]
        let result = nums.map { Double($0).convertToUnitString }
        
        XCTAssertEqual(result, expect)
    }
    func test_단위_변환_1천_미만() {
        let nums = [999, 100, 123]
        let expect = ["999", "100", "123"]
        let result = nums.map { Double($0).convertToUnitString }
        
        XCTAssertEqual(result, expect)
    }
}
