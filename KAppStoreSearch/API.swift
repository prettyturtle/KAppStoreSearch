//
//  API.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import Foundation

enum API {
    static let host = "https://itunes.apple.com"
    
    enum Path: String {
        case search = "/search"
    }
    
    static func search(keyword: String) -> NetworkRequest<SearchResponse> {
        return NetworkRequest(path: .search, queryItems: ["term": keyword, "country": "KR", "entity": "software"])
    }
}

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

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

struct SearchResponse: Codable {
    let resultCount: Int
    let results: [SearchResult]
}

struct SearchResult: Codable {
    let screenshotUrls: [String]
    let ipadScreenshotUrls: [String]
    let appletvScreenshotUrls: [String]
    let artworkUrl512: String
    let features: [String]
    let advisories: [String]
    let isGameCenterEnabled: Bool
    let supportedDevices: [String]
    let artistViewUrl: String
    let artworkUrl60: String
    let artworkUrl100: String
    let kind: String
    let userRatingCountForCurrentVersion: Int
    let currentVersionReleaseDate: String
    let releaseNotes: String
    let languageCodesISO2A: [String]
    let artistId: Int
    let artistName: String
    let genres: [String]
    let description: String
    let primaryGenreName: String
    let primaryGenreId: Int
    let releaseDate: String
    let sellerName: String
    let fileSizeBytes: String
    let averageUserRatingForCurrentVersion: Double
    let trackId: Int
    let trackName: String
    let minimumOsVersion: String
    let bundleId: String
    let genreIds: [String]
    var sellerUrl: String?
    let formattedPrice: String
    let trackContentRating: String
    let currency: String
    let trackCensoredName: String
    let trackViewUrl: String
    let contentAdvisoryRating: String
    let averageUserRating: Double
    let version: String
    let wrapperType: String
    let isVppDeviceBasedLicensingEnabled: Bool
    let price: Double
    let userRatingCount: Int
}
