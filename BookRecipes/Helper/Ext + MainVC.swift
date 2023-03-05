//
//  Ext + MainVC.swift
//  BookRecipes
//
//  Created by Ян Бойко on 03.03.2023.
//

import Foundation

extension MainVC {
    
    func fetchCollectionData(for type: Types) {
        APICaller.shared.getSortedRecipes(type: type) { results in
            switch results {
            case .success(let recipes):
                for recipe in recipes {
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
                }
                DispatchQueue.main.async {
                    self.mainView.collectionView.reloadData()
                }
            case .failure(let error):
                print (error)
                // получена ошибка
            }
        }
    }
}