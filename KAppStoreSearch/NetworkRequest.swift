//
//  NetworkRequest.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/17.
//

import Foundation

enum NetworkError: Error {
    case unknown
}

struct NetworkRequest<T: Codable> {
    private let path: API.Path
    private let queryItems: [String: String]
    
    init(path: API.Path, queryItems: [String : String]) {
        self.path = path
        self.queryItems = queryItems
    }
    
    func get(completion: @escaping (Result<T, NetworkError>) -> Void) {
        var urlComponent = URLComponents(string: API.host + path.rawValue)
        
        urlComponent?.setQueryItems(with: queryItems)
        
        guard let url = urlComponent?.url else {
            completion(.failure(.unknown))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                
                completion(.success(decodedData))
            } catch {
                completion(.failure(.unknown))
            }
        }.resume()
    }
}
