//
//  AppDetailViewController.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/17.
//

import UIKit
import SnapKit
import Then
import Cosmos

// MARK: - 앱 상세 정보 VC
final class AppDetailViewController: UIViewController {
    
    // MARK: - UI 컴포넌트
    private lazy var totalScrollView = UIScrollView()
    
    private lazy var totalContentView = UIView()
    
    private lazy var appIconImageView = UIImageView().then {
        $0.layer.cornerRadius = 30
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .placeholderText
        $0.layer.borderColor = UIColor.separator.cgColor
        $0.layer.borderWidth = 0.4
    }
    
    private lazy var appNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .label
    }
    
    private lazy var appSubTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .secondaryLabel
    }
    
    private lazy var installButton = UIButton().then {
        $0.setTitle("받기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 14
    }
    
    private lazy var subInfoScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var subInfoContentView = UIView()
    
    private lazy var subInfoStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.spacing = 8
        $0.axis = .horizontal
    }
    
    private lazy var starRatingCountView = CosmosView().then {
        $0.settings.starSize = 18
        $0.settings.starMargin = 1
        $0.settings.emptyColor = .clear
        $0.settings.emptyBorderColor = .secondaryLabel
        $0.settings.filledColor = .secondaryLabel
        $0.settings.filledBorderColor = .secondaryLabel
        $0.settings.fillMode = .precise
    }
    
    private lazy var whatsNewLabel = UILabel().then {
        $0.text = "새로운 기능"
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .label
    }
    
    private lazy var whatsNewContentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .label
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    private lazy var whatsNewContentShowMoreButton = UIButton().then {
        $0.setTitle("더 보기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0.1, left: 8, bottom: 0.1, right: 0)
        $0.layer.shadowColor = UIColor.systemBackground.cgColor
        $0.layer.shadowOpacity = 0.8
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: -8, height: 0)
        $0.backgroundColor = .systemBackground
    }
    
    private lazy var screenshotsLabel = UILabel().then {
        $0.text = "미리보기"
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
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
        setLabelAttr()
        setupScreenshotStackView(screenshotURLs: searchResult.screenshotUrls)
        setupSubInfoStackView()
        setupShowMoreButton()
    }
}

// MARK: - SET UP
extension AppDetailViewController {
    private func setLabelAttr() {
        appNameLabel.text = searchResult.trackName
        appSubTitleLabel.text = !searchResult.genres.isEmpty ? searchResult.genres[0] : (searchResult.artistName != "" ? searchResult.artistName : "")
        
        whatsNewContentLabel.text = searchResult.releaseNotes
        whatsNewContentLabel.setLineHeight(with: 8)
    }
    
    private func setupShowMoreButton() {
        if whatsNewContentLabel.currentLineCount() > 3 {
            whatsNewContentLabel.numberOfLines = 3
            totalContentView.addSubview(whatsNewContentShowMoreButton)
            
            whatsNewContentShowMoreButton.snp.makeConstraints {
                $0.trailing.bottom.equalTo(whatsNewContentLabel)
            }
        }
    }
    
    private func setupSubInfoStackView() {
        setupAppRatingInfo()
        setupAppAgeInfo()
    }
    
    private func setupAppRatingInfo() {
        let appRatingInfoView = AppSubInfoView()
        
        let appRatingInfoTopLabel = UILabel()
        appRatingInfoTopLabel.textAlignment = .center
        appRatingInfoTopLabel.text = Double(searchResult.userRatingCount).convertToUnitString + "개의 평가"
        appRatingInfoTopLabel.font = .systemFont(ofSize: 12, weight: .medium)
        appRatingInfoTopLabel.textColor = .secondaryLabel
        
        let appRatingInfoMidLabel = UILabel()
        let userRating = searchResult.averageUserRating
        
        let numberFomatter = NumberFormatter()
        
        numberFomatter.roundingMode = .floor
        numberFomatter.maximumSignificantDigits = 2
        
        let userRatingString = numberFomatter.string(for: userRating) ?? ""
        appRatingInfoMidLabel.text = userRatingString
        appRatingInfoMidLabel.textAlignment = .center
        appRatingInfoMidLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        appRatingInfoMidLabel.textColor = .secondaryLabel
        
        let appRatingInfoBottomLabel = starRatingCountView
        
        appRatingInfoBottomLabel.rating = userRating
        
        appRatingInfoView.setupView(top: appRatingInfoTopLabel, mid: appRatingInfoMidLabel, bottom: appRatingInfoBottomLabel)
        
        subInfoStackView.addArrangedSubview(appRatingInfoView)
    }
    
    private func setupAppAgeInfo() {
        let appAgeInfoView = AppSubInfoView()
        
        let appAgeInfoTopLabel = UILabel()
        appAgeInfoTopLabel.textAlignment = .center
        appAgeInfoTopLabel.text = "연령"
        appAgeInfoTopLabel.font = .systemFont(ofSize: 12, weight: .medium)
        appAgeInfoTopLabel.textColor = .secondaryLabel
        
        let appAgeInfoMidLabel = UILabel()
        appAgeInfoMidLabel.text = searchResult.contentAdvisoryRating
        appAgeInfoMidLabel.textAlignment = .center
        appAgeInfoMidLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        appAgeInfoMidLabel.textColor = .secondaryLabel
        
        let appAgeInfoBottomLabel = UILabel()
        appAgeInfoBottomLabel.textAlignment = .center
        appAgeInfoBottomLabel.text = "세"
        appAgeInfoBottomLabel.font = .systemFont(ofSize: 16, weight: .medium)
        appAgeInfoBottomLabel.textColor = .secondaryLabel
        
        appAgeInfoView.setupView(top: appAgeInfoTopLabel, mid: appAgeInfoMidLabel, bottom: appAgeInfoBottomLabel)
        
        subInfoStackView.addArrangedSubview(appAgeInfoView)
    }
    
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
            installButton,
            subInfoScrollView,
            whatsNewLabel,
            whatsNewContentLabel,
            screenshotsLabel,
            screenshotsScrollView
        ].forEach {
            totalContentView.addSubview($0)
        }
        
        appIconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
            $0.size.equalTo(120)
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
        
        subInfoScrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(appIconImageView.snp.bottom).offset(16)
            $0.height.equalTo(100)
        }
        
        subInfoScrollView.addSubview(subInfoContentView)
        
        subInfoContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        subInfoContentView.addSubview(subInfoStackView)
        
        subInfoStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
        }
        
        whatsNewLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(subInfoScrollView.snp.bottom).offset(16)
        }
        
        whatsNewContentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(whatsNewLabel.snp.bottom).offset(16)
        }
        
        screenshotsLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(whatsNewContentLabel.snp.bottom).offset(32)
        }
        
        screenshotsScrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(screenshotsLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(32)
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
