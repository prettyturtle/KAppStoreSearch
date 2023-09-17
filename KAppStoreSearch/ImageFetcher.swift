//
//  ImageFetcher.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/17.
//

import Foundation

struct ImageFetcher {
    static func fetch(_ urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil)
                return
            }
            
            if let data = data {
                completion(data)
                return
            }
        }
        .resume()
    }
}
