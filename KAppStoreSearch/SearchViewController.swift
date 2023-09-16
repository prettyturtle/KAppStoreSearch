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

extension SearchViewController {
    func setupSearchBar() {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        navigationItem.searchController = searchController
    }
    
    func setupNavigationBar() {
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
