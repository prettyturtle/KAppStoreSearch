//
//  Network.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/17.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidRequest
    case jsonError
    case serverError
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
            completion(.failure(.invalidURL))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.invalidRequest))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  (200..<300) ~= statusCode else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                
                completion(.success(decodedData))
            } catch {
                completion(.failure(.jsonError))
            }
        }
        
        dataTask.resume()
    }
}
