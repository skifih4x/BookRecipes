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
                            switch type {
                            case .popular:
                                self.popularRecipes.remove(at: 0)
                                self.popularRecipes.append(recipe)
                            case .healthy:
                                self.healthyRecipes.remove(at: 0)
                                self.healthyRecipes.append(recipe)
                            case .dessert:
                                self.dessertRecipes.remove(at: 0)
                                self.dessertRecipes.append(recipe)
                            }
                        case .failure(let error):
                            print(error)
                        }
                        dispatchGroup.leave()
                    }
                    dispatchGroup.notify(queue: .main) {
                        // Все запросы завершены
                        self.mainView.collectionView.reloadData()
                    }
                }
            case .failure(let error):
                print (error)
                // получена ошибка
            }
        }
    }
}
