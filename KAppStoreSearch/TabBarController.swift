//
//  TabBarController.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import UIKit
import Then

final class TabBarController: UITabBarController {
    
    let todayViewController = UIViewController().then {
        $0.tabBarItem = UITabBarItem(
            title: "투데이",
            image: UIImage(systemName: "doc.text.image"),
            tag: 0
        )
    }
    let gameViewController = UIViewController().then {
        $0.tabBarItem = UITabBarItem(
            title: "게임",
            image: UIImage(systemName: "gamecontroller"),
            tag: 0
        )
    }
    let appViewController = UIViewController().then {
        $0.tabBarItem = UITabBarItem(
            title: "앱",
            image: UIImage(systemName: "square.stack.3d.up.fill"),
            tag: 0
        )
    }
    let arcadeViewController = UIViewController().then {
        $0.tabBarItem = UITabBarItem(
            title: "Arcade",
            image: UIImage(systemName: "flag.checkered"),
            tag: 0
        )
    }
    let searchViewController = UINavigationController(rootViewController: SearchViewController()).then {
        $0.tabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 0
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            todayViewController,
            gameViewController,
            appViewController,
            arcadeViewController,
            searchViewController
        ]
        
        selectedIndex = (viewControllers?.count ?? 1) - 1
    }
}
