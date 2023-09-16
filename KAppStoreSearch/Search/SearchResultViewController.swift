//
//  SearchResultViewController.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import UIKit
import SnapKit
import Then

// MARK: - 검색 결과 VC
final class SearchResultViewController: UIViewController {
    
    // MARK: - UI 컴포넌트
    private lazy var searchResultTableView = UITableView().then {
        $0.dataSource = self
        $0.register(
            RecentSearchTextTableViewCell.self,
            forCellReuseIdentifier: RecentSearchTextTableViewCell.identifier
        )
    }
    
    // MARK: - 프로퍼티
    
    /// 최근 검색어 중 현재 검색 텍스트가 포함된 결과 배열
    private var recentSearchTexts = [String]()
    
    /// 검색 결과 리스트
    private var searchResults = [SearchResult]()
    
    /// 현재 검색 텍스트
    private var currentSearchText = ""
}

// MARK: - Life Cycle
extension SearchResultViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
}

// MARK: - 로직
extension SearchResultViewController {
    /// 검색 텍스트가 바뀔 때마다 호출
    func didChangeSearchText(with text: String) {
        currentSearchText = text
        
        // TODO: - 최근 검색어 리스트에 있는지 찾기
    }
    
    /// 검색 버튼을 눌렀을 때 호출
    func didClickedSearchButton(with text: String) {
        // TODO: - 최근 검색어에 저장하기
        
        // TODO: - 검색 결과 보여주기
    }
}

// MARK: - UITableViewDataSource
extension SearchResultViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return recentSearchTexts.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecentSearchTextTableViewCell.identifier,
            for: indexPath
        ) as? RecentSearchTextTableViewCell else {
            return UITableViewCell()
        }
        
        if !recentSearchTexts.isEmpty {
            cell.setupView(recentSearchText: recentSearchTexts[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - SET UP
extension SearchResultViewController {
    private func setupLayout() {
        view.addSubview(searchResultTableView)
        
        searchResultTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
