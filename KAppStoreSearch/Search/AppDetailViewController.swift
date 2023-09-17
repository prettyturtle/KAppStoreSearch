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
    }
}
