//
//  SearchResultTableViewCell.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/17.
//

import UIKit
import SnapKit
import Then

final class SearchResultTableViewCell: UITableViewCell, CellIdentifier {
    private lazy var titleLabel = UILabel()
    
    func setup(_ searchResult: SearchResult) {
        setupLayout()
        titleLabel.text = searchResult.trackName
    }
    
    private func setupLayout() {
        [
            titleLabel
        ].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
}
