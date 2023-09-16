//
//  SearchViewController.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import UIKit

// MARK: - 검색 VC
final class SearchViewController: UIViewController {
    
    /// 검색 결과 VC
    private let searchResultViewController = SearchResultViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchBar()
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
}
