//
//  CacheManager.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/18.
//

import UIKit

final class CacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
