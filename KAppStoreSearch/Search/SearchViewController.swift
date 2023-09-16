//
//  SearchViewController.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import UIKit

final class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchBar()
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let currentSearchText = searchController.searchBar.text ?? "" // 검색 텍스트
        
        print(currentSearchText)
    }
}

extension SearchViewController {
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: SearchResultTableViewController())
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func setupNavigationBar() {
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
