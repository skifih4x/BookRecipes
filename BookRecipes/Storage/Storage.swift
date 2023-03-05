//
//  DataBase.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 05.03.2023.
//

import RealmSwift

class DataBase {
    
    static let shared = DataBase()

    private let realm = try! Realm()
    private var items: Results<RealmRecipe>!
    
    private init() { }
    
    func write(recipe: DetailedRecipe) {
        
        let realmRecipe = RealmRecipe()
        
        realmRecipe.id = recipe.id
        
        try! realm.write({
            realm.add(realmRecipe)
        })
    }
    
    func read(completion: @escaping (Results<RealmRecipe>) -> ()) {
        items = realm.objects(RealmRecipe.self)
        completion(items)
    }
    
    func deleteAll() {
        
        try! realm.write {
            let allRecipes = realm.objects(RealmRecipe.self)
            realm.delete(allRecipes)
        }
        
    }
}
