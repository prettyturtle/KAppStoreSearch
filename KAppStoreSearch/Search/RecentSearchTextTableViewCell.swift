//
//  RecentSearchTextTableViewCell.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import UIKit
import SnapKit
import Then

// MARK: - 최근 검색어 테이블 뷰 셀 델리게이트
protocol RecentSearchTextTableViewCellDelegate: AnyObject {
    func removeRecentSearchText(at recentSearchText: String?)
}

// MARK: - 최근 검색어 테이블 뷰 셀
final class RecentSearchTextTableViewCell: UITableViewCell, CellIdentifier {
    
    // MARK: - UI 컴포넌트
    private lazy var magnifyingGlassIcon = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.tintColor = .lightGray
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .label
    }
    
    private lazy var removeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.tintColor = .lightGray
        $0.addTarget(
            self,
            action: #selector(didTapRemoveButton),
            for: .touchUpInside
        )
    }
    
    // MARK: - 프로퍼티
    weak var delegate: RecentSearchTextTableViewCellDelegate?
    
    /// 최근 검색어 텍스트
    var recentSearchText: String?
    
    /// 셀 세팅
    /// - Parameters:
    ///   - hasIcon: 검색어 라벨 앞에 돋보기 아이콘 존재 여부
    func setupView(hasIcon: Bool) {
        setupLayout(hasIcon: hasIcon)
        
        setTitleLabelAttr(hasIcon: hasIcon)
    }
    
    /// 최근 검색어 라벨 속성 세팅
    private func setTitleLabelAttr(hasIcon: Bool) {
        titleLabel.text = recentSearchText
        
        if !hasIcon { // 라벨 왼쪽에 돋보기 아이콘 없을 때
            titleLabel.font = .systemFont(ofSize: 22, weight: .regular)
            titleLabel.textColor = .systemBlue
        }
    }
}

// MARK: - UI Event
extension RecentSearchTextTableViewCell {
    @objc func didTapRemoveButton() {
        delegate?.removeRecentSearchText(at: recentSearchText)
    }
}

// MARK: - SET UP
extension RecentSearchTextTableViewCell {
    private func setupLayout(hasIcon: Bool) {
        if hasIcon {
            [
                magnifyingGlassIcon,
                titleLabel
            ].forEach {
                addSubview($0)
            }
            
            magnifyingGlassIcon.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(16)
                $0.top.equalTo(titleLabel.snp.top)
                $0.bottom.equalTo(titleLabel.snp.bottom)
                $0.width.equalTo(magnifyingGlassIcon.snp.height)
            }
            
            titleLabel.snp.makeConstraints {
                $0.leading.equalTo(magnifyingGlassIcon.snp.trailing).offset(12)
                $0.trailing.equalToSuperview().inset(16)
                $0.top.bottom.equalToSuperview().inset(8)
            }
        } else {
            [
                titleLabel,
                removeButton
            ].forEach {
                addSubview($0)
            }
            
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(16)
                $0.trailing.equalTo(removeButton.snp.leading).inset(-16)
                $0.top.bottom.equalToSuperview().inset(8)
            }
            
            removeButton.snp.makeConstraints {
                $0.size.equalTo(titleLabel.snp.height)
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(16)
            }
        }
    }
}
