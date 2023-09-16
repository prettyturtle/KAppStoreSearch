//
//  SceneDelegate.swift
//  KAppStoreSearch
//
//  Created by yc on 2023/09/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        
        let rootViewController = TabBarController()
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}
