//
//  Ext + RealmDataBase.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 10.03.2023.
//

import Foundation

extension RealmDataBase {
    func createCompletion(with recipe: RecipeProtocol) -> (() -> ()) {
        let closure = {
            if RealmDataBase.shared.isItemSaved(withId: recipe.id) {
                RealmDataBase.shared.deleteitem(withId: recipe.id)
            } else {
                RealmDataBase.shared.write(recipe: recipe)
            }
        }
        return closure
    }
}
