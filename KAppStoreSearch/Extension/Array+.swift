//
//  Array+.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/18.
//

import Foundation

extension Array where Element == String {
    func search(of text: String) -> [String] {
        let lowercasedText = text.lowercased()
        
        return map { $0.lowercased() }
            .filter { $0.hasPrefix(lowercasedText) || $0.hasSuffix(lowercasedText) }
    }
}
