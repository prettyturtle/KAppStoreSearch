//
//  AppSubInfoView.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/17.
//

import UIKit
import SnapKit

final class AppSubInfoView: UIView {
    
    private lazy var topView = UIView()
    private lazy var midView = UIView()
    private lazy var bottomView = UIView()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(top: UIView, mid: UIView, bottom: UIView) {
        topView.addSubview(top)
        midView.addSubview(mid)
        bottomView.addSubview(bottom)
        
        [top, mid, bottom].forEach { subView in
            subView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    private func setupLayout() {
        [
            topView,
            midView,
            bottomView
        ].forEach {
            addSubview($0)
        }
        
        topView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(8)
        }
        
        midView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.equalTo(topView.snp.bottom).offset(12)
            $0.height.equalTo(24)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview().inset(8)
            $0.top.equalTo(midView.snp.bottom).offset(12)
        }
    }
}
