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
    private lazy var appIconImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    private lazy var appNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .label
    }
    private lazy var appSubTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .secondaryLabel
    }
    private lazy var starRatingCountView = UIView().then { // TODO: 별점 커스텀 뷰
        $0.backgroundColor = .secondaryLabel
    }
    private lazy var ratingCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .lightGray
    }
    private lazy var installButton = UIButton().then {
        $0.setTitle("받기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.cornerRadius = 18
    }
    private lazy var screenshotsStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.spacing = 8
        $0.axis = .horizontal
    }
    
    func setupView(_ searchResult: SearchResult) {
        setupLayout()
        
        ImageFetcher.fetch(searchResult.artworkUrl512) { [weak self] data in
            guard let data = data else {
                self?.appIconImageView.backgroundColor = .lightGray
                return
            }
            
            DispatchQueue.main.async {
                self?.appIconImageView.image = UIImage(data: data)
            }
        }
        
        appNameLabel.text = searchResult.trackName
        appSubTitleLabel.text = searchResult.artistName == "" ? "X" : searchResult.artistName
        ratingCountLabel.text = "1.1만"
        
        for i in 0..<searchResult.screenshotUrls.count {
            let screenshotURL = searchResult.screenshotUrls[i]
            let screenshotSize = screenshotURL.split(separator: "/").last?.split(separator: "b").first?.split(separator: "x").map { Double($0) } ?? []
            
            var screenshotWidth = 392.0
            var screenshotHeight = 696.0
            
            if screenshotSize.count == 2 {
                screenshotWidth = screenshotSize[0] ?? screenshotWidth
                screenshotHeight = screenshotSize[1] ?? screenshotHeight
            }
            
            if screenshotWidth < screenshotHeight {
                if i == 3 {
                    break
                }
            } else {
                if i == 1 {
                    break
                }
            }
            
            let imageView = UIImageView()
            
            ImageFetcher.fetch(searchResult.screenshotUrls[i]) { data in
                guard let data = data else {
                    imageView.backgroundColor = .lightGray
                    return
                }
                
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
                
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
            
            imageView.snp.makeConstraints {
                $0.height.equalTo(imageView.snp.width).multipliedBy(screenshotHeight / screenshotWidth)
            }
            screenshotsStackView.addArrangedSubview(imageView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        appIconImageView.image = nil
        
        screenshotsStackView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func setupLayout() {
        [
            appIconImageView,
            appNameLabel,
            appSubTitleLabel,
            starRatingCountView,
            ratingCountLabel,
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
            $0.top.equalTo(appNameLabel.snp.bottom).offset(8)
        }
        
        starRatingCountView.snp.makeConstraints {
            $0.leading.trailing.equalTo(appNameLabel)
            $0.top.equalTo(appSubTitleLabel.snp.bottom).offset(8)
            $0.height.equalTo(14)
            $0.bottom.equalTo(appIconImageView.snp.bottom)
        }
        
        installButton.snp.makeConstraints {
            $0.leading.equalTo(appNameLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(80)
            $0.height.equalTo(36)
            $0.centerY.equalTo(appIconImageView.snp.centerY)
        }
        
        screenshotsStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(appIconImageView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}
