//
//  CellIdentifier.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import Foundation

protocol CellIdentifier {
    static var identifier: String { get }
}

extension CellIdentifier {
    static var identifier: String { String(describing: self) }
}
