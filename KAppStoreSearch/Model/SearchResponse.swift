//
//  SearchResponse.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/17.
//

import Foundation

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
