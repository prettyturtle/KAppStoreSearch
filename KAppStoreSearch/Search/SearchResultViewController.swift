//
//  SearchResultViewController.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import UIKit
import SnapKit
import Then

// MARK: - 검색 결과 VC 델리게이트
protocol SearchResultViewControllerDelegate: AnyObject {
    func didTapSearchResult(of searchResult: SearchResult)
    func didSelectRecentSearchText(of text: String)
}

// MARK: - 검색 결과 VC
final class SearchResultViewController: UIViewController {
    
    // MARK: - UI 컴포넌트
    private lazy var searchResultTableView = UITableView().then {
        $0.dataSource = self
        $0.delegate = self
        $0.register(
            RecentSearchTextTableViewCell.self,
            forCellReuseIdentifier: RecentSearchTextTableViewCell.identifier
        )
        $0.register(
            SearchResultTableViewCell.self,
            forCellReuseIdentifier: SearchResultTableViewCell.identifier
        )
    }
    
    // MARK: - 프로퍼티
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    /// 최근 검색어 중 현재 검색 텍스트가 포함된 결과 배열
    private var recentSearchTexts = [String]()
    
    /// 검색 결과 리스트
    private var searchResults = [SearchResult]()
    
    /// 현재 검색 텍스트
    private var currentSearchText = ""
    
    /// 검색 완료 플래그
    private var isEndSearch = false
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
        isEndSearch = false
        
        currentSearchText = text
        
        recentSearchTexts = findTextFromRecentSearchTextList(text)
        
        searchResultTableView.reloadData()
    }
    
    /// 검색 버튼을 눌렀을 때 호출
    func didClickedSearchButton(with text: String) {
        isEndSearch = true
        
        saveAtRecentSearchTextList(text)
        
        fetchSearchResult(keyword: text)
    }
    
    /// 최근 검색어 리스트에 있는지 찾기
    private func findTextFromRecentSearchTextList(_ text: String) -> [String] {
        let recentSearchTextList: [String] = UserDefaults.standard.fetch(key: .recentSearchTextList) ?? []
        let filteredRecentSearchTextList = recentSearchTextList.filter {
            $0.lowercased().hasPrefix(text.lowercased())
        }
        
        return filteredRecentSearchTextList
    }
    
    /// 최근 검색어에 저장하기
    private func saveAtRecentSearchTextList(_ text: String) {
        let whiteSpaceRemovedText = text.replacingOccurrences(of: " ", with: "") // 띄어쓰기를 제거한 검색어
        
        guard whiteSpaceRemovedText != "" else { // 띄어쓰기만 입력한 경우에 대한 예외처리
            return
        }
        
        do {
            try UserDefaults.standard.save(text, key: .recentSearchTextList)
        } catch {
            print("ERROR : \(error)")
        }
    }
    
    /// 검색 결과 보여주기
    private func fetchSearchResult(keyword: String) {
        API.search(keyword: keyword).`get` { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let searchResponse):
                self.searchResults = searchResponse.results
                
                DispatchQueue.main.async {
                    self.searchResultTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchResultViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if isEndSearch {
            tableView.separatorStyle = .none
            return searchResults.count
        } else {
            tableView.separatorStyle = .singleLine
            return recentSearchTexts.count
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if isEndSearch {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultTableViewCell else {
                return UITableViewCell()
            }
            
            cell.setupView(searchResults[indexPath.row])
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RecentSearchTextTableViewCell.identifier,
                for: indexPath
            ) as? RecentSearchTextTableViewCell else {
                return UITableViewCell()
            }
            
            if !recentSearchTexts.isEmpty {
                cell.setupView(recentSearchText: recentSearchTexts[indexPath.row], hasIcon: true)
            }
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let _ = tableView.cellForRow(at: indexPath) as? RecentSearchTextTableViewCell {
            delegate?.didSelectRecentSearchText(of: recentSearchTexts[indexPath.row])
        } else if let _ = tableView.cellForRow(at: indexPath) as? SearchResultTableViewCell {
            delegate?.didTapSearchResult(of: searchResults[indexPath.row])
        }
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
