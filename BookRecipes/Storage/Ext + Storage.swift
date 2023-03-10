//
//  Ext + Storage.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 10.03.2023.
//

import Foundation

extension Storage {
    func createCompletion(with recipe: RecipeProtocol) -> (() -> ()) {
        let closure = {
            if Storage.shared.isItemSaved(withId: recipe.id) {
                Storage.shared.deleteitem(withId: recipe.id)
            } else {
                Storage.shared.write(recipe: recipe)
            }
        }
        return closure
    }
}
