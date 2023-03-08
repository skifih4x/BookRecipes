//
//  SceneDelegate.swift
//  BookRecipes
//
//  Created by Артем Орлов on 26.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navController = UINavigationController()
        navController.navigationBar.isHidden = true
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navController
        //window?.rootViewController = onVC
        //window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        if UserDefaults.standard.bool(forKey: "hasOnboarded") {
           // UserDefaults.standard.set(false, forKey: "hasOnboarded") // раскоментить, если требуется показать онбординг еще раз
            let tabBarController = BaseTabBarController()
            navController.pushViewController(tabBarController, animated: true)
        } else {
            let onVC = OnboardingContainerViewController()
            navController.pushViewController(onVC, animated: true)
        }
        
        
    }
}

