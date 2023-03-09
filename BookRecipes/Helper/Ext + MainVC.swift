//
//  Ext + MainVC.swift
//  BookRecipes
//
//  Created by Ян Бойко on 03.03.2023.
//

import Foundation

extension MainVC {
    
    func fetchCollectionData(for type: Types) {
        APICaller.shared.getCategoryRecipes(sorted: true, searchParameter: type.rawValue) { results in
            switch results {
            case .success(let recipes):
                self.recipesModels = self.recipesModels + recipes
                for recipe in recipes {
                    switch type {
                    case .popularity:
                        self.popularRecipes.remove(at: 0)
                        self.popularRecipes.append(recipe)
                    case .healthiness:
                        self.healthyRecipes.remove(at: 0)
                        self.healthyRecipes.append(recipe)
                    case .sugar:
                        self.dessertRecipes.remove(at: 0)
                        self.dessertRecipes.append(recipe)
                    }
                }
                DispatchQueue.main.async {
                    self.mainView.collectionView.reloadData()
                    self.searchedRecipes = self.recipesModels
                    self.updateMainTableView()
                }
            case .failure(let error):
                print (error)
                // получена ошибка
            }
        }
    }
}
