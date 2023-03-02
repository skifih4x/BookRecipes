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
        fetchData()
        view.addSubview(mainView)
        constraintView()
        
    }
    
    func constraintView() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func fetchData() {
        let dispatchGroup = DispatchGroup()
        APICaller.shared.getSortedRecipes(type: .popular) { results in
            switch results {
            case .success(let recipes):
                // Успешно получено
                for i in recipes {
                    dispatchGroup.enter()
                    APICaller.shared.getDetailedRecipe(with: i.id) { results in
                        switch results {
                        case .success(let recipe):
                            print(recipe)
                            // успешно получены детальные данные
                            APICaller.shared.getImage(from: recipe.image!) { result in
                                switch result {
                                case .success(let imageData):
                                    let safeRecipe = SafeRecipe(recipe: recipe, imageData: imageData)
                                    self.mainView.popularRecipes.append(safeRecipe)
                                case .failure(let error):
                                    print(error)
                                }
                                dispatchGroup.leave()
                            }
                        case .failure(let error):
                            print(error)
                            // получена ошибка при запросе детальных данных
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self.mainView.collectionView.reloadData()
                }
                
            case .failure(let error):
                print (error)
                // получена ошибка
            }
        }
    }
    
//    func fetchData() {
//        APICaller.shared.getSortedRecipes(type: .popular) { results in
//            switch results {
//            case .success(let recipes):
//                // Успешно получено
//                for i in recipes {
//                    APICaller.shared.getDetailedRecipe(with: i.id) { results in
//                        switch results {
//                        case .success(let recipe):
//                            print(recipe)
//                            // успешно получены детальные данные
//                            APICaller.shared.getImage(from: recipe.image!) { result in
//                                switch result {
//                                case .success(let imageData):
//                                    let safeRecipe = SafeRecipe(recipe: recipe, imageData: imageData)
//                                    self.mainView.popularRecipes.append(safeRecipe)
//                                case .failure(let error):
//                                    print(error)
//                                }
//                            }
//                        case .failure(let error):
//                            print(error)
//                            // получена ошибка при запросе детальных данных
//                        }
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.mainView.collectionView.reloadData()
//                }
//
//            case .failure(let error):
//                print (error)
//                // получена ошибка
//            }
//        }
//    }
}


