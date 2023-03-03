//
//  Ext + MainVC.swift
//  BookRecipes
//
//  Created by Ян Бойко on 03.03.2023.
//

import Foundation

extension MainVC {
    
    func fetchData(for type: Types) {
        let dispatchGroup = DispatchGroup()
        APICaller.shared.getSortedRecipes(type: type) { results in
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
                                    switch type {
                                    case .popular:
                                        self.mainView.popularRecipes.append(safeRecipe)
                                    case .healthy:
                                        self.mainView.healthyRecipes.append(safeRecipe)
                                    case .dessert:
                                        self.mainView.dessertRecipes.append(safeRecipe)
                                    }
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
}
