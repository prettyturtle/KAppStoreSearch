//
//  RecentSearchTextTableViewCell.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import UIKit
import SnapKit
import Then

final class RecentSearchTextTableViewCell: UITableViewCell, CellIdentifier {
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .label
    }
    
    func setupView(recentSearchText: String) {
        setupLayout()
        
        titleLabel.text = recentSearchText
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
