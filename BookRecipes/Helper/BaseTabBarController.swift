//
//  BaseTabBarController.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        viewControllers = [
            createNavController(viewController: MainVC(), title: "Main", imageName: "main"),
            createNavController(viewController: CategoriesVC(), title: "Categories", imageName: "category"),
            createNavController(viewController: SavedVC(), title: "Saved", imageName: "saved"),
        ]
    }
    
    private func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        viewController.title = title
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
    
}
