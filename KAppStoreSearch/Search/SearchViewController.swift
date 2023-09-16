//
//  SearchViewController.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import UIKit

// MARK: - 검색 VC
final class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchBar()
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    // 검색 바의 텍스트가 변경될 때마다 호출
    func updateSearchResults(for searchController: UISearchController) {
        
        let currentSearchText = searchController.searchBar.text ?? "" // 검색 텍스트
        
        print(currentSearchText)
    }
}

// MARK: - SET UP
extension SearchViewController {
    /// 검색 바 세팅
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: SearchResultTableViewController())
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    /// 내비게이션 바 세팅
    func setupNavigationBar() {
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
