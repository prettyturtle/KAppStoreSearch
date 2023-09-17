//
//  ImageFetcher.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/17.
//

import UIKit

struct ImageFetcher {
    static func fetch(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let cachedImage = CacheManager.shared.object(forKey: urlString as NSString) {
                completion(cachedImage)
                return
            }
            
            if let _ = error {
                completion(nil)
                return
            }
            
            if let data = data,
               let fetchedImage = UIImage(data: data) {
                
                CacheManager.shared.setObject(fetchedImage, forKey: urlString as NSString)
                completion(fetchedImage)
                return
            } else {
                completion(nil)
                return
            }
        }
        .resume()
    }
}
