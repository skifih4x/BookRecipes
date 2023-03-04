//
//  MainVC.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit

class MainVC: UIViewController {
    
    var mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        constraintView()
        fetchData()
    }
    
    func fetchData() {
        fetchData(for: .popular)
        fetchData(for: .healthy)
        fetchData(for: .dessert)
    }
    
    func constraintView() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}


