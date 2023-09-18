//
//  SearchResultTableViewCell.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/17.
//

import UIKit
import SnapKit
import Then
import Cosmos

// MARK: - 앱 검색 결과 테이블 뷰 셀
final class SearchResultTableViewCell: UITableViewCell, CellIdentifier {
    
    // MARK: - UI 컴포넌트
    private lazy var appIconImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .placeholderText
        $0.layer.borderColor = UIColor.separator.cgColor
        $0.layer.borderWidth = 0.4
    }
    
    private lazy var appNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .label
    }
    
    private lazy var appSubTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .secondaryLabel
    }
    
    private lazy var starRatingCountView = CosmosView().then {
        $0.settings.starSize = 16
        $0.settings.starMargin = 2
        $0.settings.emptyColor = .clear
        $0.settings.emptyBorderColor = .darkGray
        $0.settings.filledColor = .darkGray
        $0.settings.filledBorderColor = .darkGray
        $0.settings.fillMode = .precise
    }
    
    private lazy var installButton = UIButton().then {
        $0.setTitle("받기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.cornerRadius = 14
    }
    
    private lazy var screenshotsStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.spacing = 8
        $0.axis = .horizontal
    }
    
    /// 전체 뷰 세팅
    func setupView(_ searchResult: SearchResult) {
        setupLayout()
        
        setupAppIconImageView(iconURL: searchResult.artworkUrl512)
        setupScreenshotStackView(screenshotURLs: searchResult.screenshotUrls)
        
        appNameLabel.text = searchResult.trackName
        appSubTitleLabel.text = !searchResult.genres.isEmpty ? searchResult.genres[0] : (searchResult.artistName != "" ? searchResult.artistName : "")
        
        starRatingCountView.rating = searchResult.averageUserRating
        starRatingCountView.text = Double(searchResult.userRatingCount).convertToUnitString
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        appIconImageView.image = nil
        
        screenshotsStackView.subviews.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - SET UP
extension SearchResultTableViewCell {
    /// 앱 아이콘 세팅
    private func setupAppIconImageView(iconURL: String) {
        ImageFetcher.fetch(iconURL) { [weak self] image in
            guard let image = image else {
                return
            }
            
            DispatchQueue.main.async {
                self?.appIconImageView.image = image
            }
        }
    }
    
    /// 스크린샷 세팅
    private func setupScreenshotStackView(screenshotURLs: [String]) {
        for i in 0..<screenshotURLs.count {
            let screenshotURL = screenshotURLs[i]
            let screenshotSize = screenshotURL
                .split(separator: "/")
                .last?
                .split(separator: "b")
                .first?
                .split(separator: "x")
                .map { Double($0) } ?? []
            
            var screenshotWidth = 392.0
            var screenshotHeight = 696.0
            
            if screenshotSize.count == 2 {
                screenshotWidth = screenshotSize[0] ?? screenshotWidth
                screenshotHeight = screenshotSize[1] ?? screenshotHeight
            }
            
            let imageCountLimit = screenshotWidth < screenshotHeight ? 3 : 1    // 스크린샷 개수 = 세로형 : 3개, 가로형 : 1개
            
            if i == imageCountLimit {
                return
            }
            
            let screenshotImageView = UIImageView()
            
            screenshotImageView.backgroundColor = .placeholderText
            screenshotImageView.contentMode = .scaleAspectFit
            screenshotImageView.clipsToBounds = true
            screenshotImageView.layer.cornerRadius = 8
            screenshotImageView.layer.borderColor = UIColor.separator.cgColor
            screenshotImageView.layer.borderWidth = 0.4
            
            screenshotImageView.snp.makeConstraints {
                $0.height.equalTo(screenshotImageView.snp.width).multipliedBy(screenshotHeight / screenshotWidth)
            }
            screenshotsStackView.addArrangedSubview(screenshotImageView)
            
            ImageFetcher.fetch(screenshotURL) { image in
                guard let image = image else {
                    return
                }
                
                DispatchQueue.main.async {
                    screenshotImageView.image = image
                }
            }
        }
    }
    
    /// 레이아웃 세팅
    private func setupLayout() {
        [
            appIconImageView,
            appNameLabel,
            appSubTitleLabel,
            starRatingCountView,
            installButton,
            screenshotsStackView
        ].forEach {
            addSubview($0)
        }
        
        appIconImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16)
            $0.size.equalTo(72)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            $0.top.equalTo(appIconImageView.snp.top)
        }
        
        appSubTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(appNameLabel)
            $0.top.equalTo(appNameLabel.snp.bottom).offset(4)
        }
        
        starRatingCountView.snp.makeConstraints {
            $0.leading.equalTo(appNameLabel)
            $0.bottom.equalTo(appIconImageView.snp.bottom)
        }
        
        installButton.snp.makeConstraints {
            $0.leading.equalTo(appNameLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(80)
            $0.height.equalTo(28)
            $0.centerY.equalTo(appIconImageView.snp.centerY)
        }
        
        screenshotsStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(appIconImageView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
}
