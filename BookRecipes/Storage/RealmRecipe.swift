//
//  RecipeRealm.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 05.03.2023.
//

import RealmSwift
import Foundation

class RealmRecipe: Object {
    @Persisted var id : Int
    @Persisted var title : String
    @Persisted var image = Data()
}
