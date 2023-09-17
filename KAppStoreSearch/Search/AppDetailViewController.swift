//
//  AppDetailViewController.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/17.
//

import UIKit
import SnapKit
import Then

// MARK: - 앱 상세 정보 VC
final class AppDetailViewController: UIViewController {
    
    // MARK: - UI 컴포넌트
    private lazy var totalScrollView = UIScrollView()
    private lazy var totalContentView = UIView()
    
    private lazy var appIconImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .placeholderText
        $0.layer.borderColor = UIColor.separator.cgColor
        $0.layer.borderWidth = 0.4
    }
    private lazy var appNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .label
    }
    private lazy var appSubTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .secondaryLabel
    }
//    private lazy var starRatingCountView = CosmosView().then {
//        $0.settings.starSize = 16
//        $0.settings.starMargin = 2
//        $0.settings.emptyColor = .clear
//        $0.settings.emptyBorderColor = .darkGray
//        $0.settings.filledColor = .darkGray
//        $0.settings.filledBorderColor = .darkGray
//        $0.settings.fillMode = .precise
//    }
    
    private lazy var installButton = UIButton().then {
        $0.setTitle("받기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 14
    }
    private lazy var screenshotsLabel = UILabel().then {
        $0.text = "미리보기"
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .label
    }
    private lazy var screenshotsScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    private lazy var screenshotsContentView = UIView()
    private lazy var screenshotsStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.spacing = 8
        $0.axis = .horizontal
    }
    
    // MARK: - 프로퍼티
    /// 검색 결과 (앱 정보)
    let searchResult: SearchResult
    
    init(searchResult: SearchResult) {
        self.searchResult = searchResult
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension AppDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        setupLayout()
        setupView()
    }
}

extension AppDetailViewController {
    func setupView() {
        
        setupAppIconImageView(iconURL: searchResult.artworkUrl512)
        setupScreenshotStackView(screenshotURLs: searchResult.screenshotUrls)
        
        appNameLabel.text = searchResult.trackName
        appSubTitleLabel.text = !searchResult.genres.isEmpty ? searchResult.genres[0] : (searchResult.artistName != "" ? searchResult.artistName : "")
    }
}

// MARK: - SET UP
extension AppDetailViewController {
    private func setupAppIconImageView(iconURL: String) {
        ImageFetcher.fetch(iconURL) { [weak self] data in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                self?.appIconImageView.image = UIImage(data: data)
            }
        }
    }
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
            
            let screenshotImageView = UIImageView()
            
            screenshotImageView.backgroundColor = .placeholderText
            screenshotImageView.contentMode = .scaleAspectFit
            screenshotImageView.clipsToBounds = true
            screenshotImageView.layer.cornerRadius = 8
            screenshotImageView.layer.borderColor = UIColor.separator.cgColor
            screenshotImageView.layer.borderWidth = 0.4
            
            screenshotImageView.snp.makeConstraints {
                $0.width.equalTo(view.frame.width * 0.6)
                $0.height.equalTo(screenshotImageView.snp.width).multipliedBy(screenshotHeight / screenshotWidth)
            }
            screenshotsStackView.addArrangedSubview(screenshotImageView)
            
            ImageFetcher.fetch(screenshotURL) { data in
                guard let data = data else {
                    return
                }
                
                DispatchQueue.main.async {
                    screenshotImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(totalScrollView)
        
        totalScrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        totalScrollView.addSubview(totalContentView)
        
        totalContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [
            appIconImageView,
            appNameLabel,
            appSubTitleLabel,
//            starRatingCountView,
            installButton,
            screenshotsLabel,
            screenshotsScrollView
        ].forEach {
            totalContentView.addSubview($0)
        }
        
        appIconImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16)
            $0.size.equalTo(100)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(16)
            $0.top.equalTo(appIconImageView.snp.top)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        appSubTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(appNameLabel)
            $0.top.equalTo(appNameLabel.snp.bottom).offset(4)
        }
        
        installButton.snp.makeConstraints {
            $0.leading.equalTo(appNameLabel.snp.leading)
            $0.bottom.equalTo(appIconImageView.snp.bottom)
            $0.width.equalTo(80)
            $0.height.equalTo(28)
        }
        
        screenshotsLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(appIconImageView.snp.bottom).offset(16)
        }
        
        screenshotsScrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(screenshotsLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
        }
        
        screenshotsScrollView.addSubview(screenshotsContentView)
        
        screenshotsContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        screenshotsContentView.addSubview(screenshotsStackView)
        
        screenshotsStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
        }
    }
}
