//
//  SearchViewController.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import UIKit
import SnapKit
import Then

// MARK: - 검색 VC
final class SearchViewController: UIViewController {
    
    // MARK: - UI 컴포넌트
    private lazy var recentSearchTextTitleLabel = UILabel().then {
        $0.text = "최근 검색어"
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    private lazy var recentSearchTextTableView = UITableView().then {
        $0.isScrollEnabled = false
        $0.dataSource = self
        $0.register(
            RecentSearchTextTableViewCell.self,
            forCellReuseIdentifier: RecentSearchTextTableViewCell.identifier
        )
    }
    
    // MARK: - 프로퍼티
    
    /// 검색 결과 VC
    private let searchResultViewController = SearchResultViewController()
    
    /// 최근 검색어 최대 노출 개수
    private let recentSearchTextListCountLimit = 4
    
    /// 최근 검색어 리스트
    private var recentSearchTextList = [String]()
}

// MARK: - Life Cycle
extension SearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchBar()
        setupLayout()
        
        fetchRecentSearchTextList()
    }
}

// MARK: - 로직
extension SearchViewController {
    /// 최근 검색어 리스트 가져오기
    ///
    /// 최근 검색어 리스트를 가져오고 테이블 뷰를 Reload 한다
    func fetchRecentSearchTextList() {
        recentSearchTextList = UserDefaults.standard.fetch(key: .recentSearchTextList) ?? []
        recentSearchTextTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchTextList.count < 5 ? recentSearchTextList.count : recentSearchTextListCountLimit
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecentSearchTextTableViewCell.identifier,
            for: indexPath
        ) as? RecentSearchTextTableViewCell else {
            return UITableViewCell()
        }
        
        let recentSearchText = recentSearchTextList[indexPath.row]
        cell.setupView(recentSearchText: recentSearchText, hasIcon: false)
        
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    // 검색 텍스트가 바뀔 때마다 호출
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResultViewController.didChangeSearchText(with: searchText)
    }
    
    // 검색 버튼을 눌렀을 때 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultViewController.didClickedSearchButton(with: searchBar.text ?? "")
        fetchRecentSearchTextList()
    }
}

// MARK: - SET UP
extension SearchViewController {
    /// 검색 바 세팅
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    /// 내비게이션 바 세팅
    private func setupNavigationBar() {
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupLayout() {
        [
            recentSearchTextTitleLabel,
            recentSearchTextTableView
        ].forEach {
            view.addSubview($0)
        }
        
        recentSearchTextTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
        }
        
        recentSearchTextTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(recentSearchTextTitleLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview()
        }
    }
}
