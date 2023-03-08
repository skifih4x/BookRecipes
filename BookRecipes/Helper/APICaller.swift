//
//  APICaller.swift
//  BookRecipes
//
//  Created by User on 01.03.2023.
//

import Foundation
import UIKit

struct Constants {
    

    //static let APIKey = "7e31fd338a334d03aafda200f55348c0"
    //static let APIKey = "3632101b02674a0e97fb8b63eb12646e"
    //static let APIKey = "4ea5853dc94c40a296c7ac12e7fe5eb4"
    //static let APIKey = "04864a53f7464c90820b2725af2c6ba0"
    //static let APIKey = "206625f6a74745dda3cb47905f129e1c"
    //static let APIKey = "bc63ec8984094be58b7a2d77da76b373"
    //static let APIKey = "4ea5853dc94c40a296c7ac12e7fe5eb4"
    //static let APIKey = "53848099fdeb4d0d9ad71bb84a1103e2"
//    static let APIKey = "7e31fd338a334d03aafda200f55348c0"
//    static let APIKey = "3632101b02674a0e97fb8b63eb12646e"
//    static let APIKey = "4ea5853dc94c40a296c7ac12e7fe5eb4"
//    static let APIKey = "04864a53f7464c90820b2725af2c6ba0"
//    static let APIKey = "206625f6a74745dda3cb47905f129e1c"
//    static let APIKey = "bc63ec8984094be58b7a2d77da76b373"
//    static let APIKey = "4ea5853dc94c40a296c7ac12e7fe5eb4"
//    static let APIKey = "53848099fdeb4d0d9ad71bb84a1103e2"
//    static let APIKey = "c5579ba8b4734f44b80f0348e3a39505"
    static let APIKey = "9dffb89689f44ef994d6afae93681784"
    
    static let basicURL = "https://api.spoonacular.com/recipes/"
    
    static func exactURL(with id: Int) -> String {
        return "\(basicURL)\(id)/information?apiKey=\(APIKey)"
    }
    static let popularRecipesURL = "\(basicURL)complexSearch?sort=popularity&number=10&apiKey=\(APIKey)"
    static let healthyRecipesURL = "\(basicURL)complexSearch?sort=healthiness&number=10&apiKey=\(APIKey)"
    static let dessertRecipesURL = "\(basicURL)complexSearch?sort=sugar&number=10&apiKey=\(APIKey)"
    static let randomURL = "\(basicURL)random?apiKey=\(APIKey)"
    static let searchRecipeURL = "\(basicURL)autocomplete?number=10&apiKey=\(APIKey)&query="
    static let ingredientImageURL = "https://spoonacular.com/cdn/ingredients_100x100/"
    
    static func categoryURL(with category: String) -> String {
        return "https://api.spoonacular.com/recipes/complexSearch?type=\(category)&apiKey=\(APIKey)"
    }

}

enum Types {
    case popular
    case healthy
    case dessert
}

class APICaller {
    
    static let shared = APICaller()
    
    func getDetailedRecipe (with id: Int, completion: @escaping (Result<DetailedRecipe, Error>) -> Void) {
        
        guard let url = URL(string: Constants.exactURL(with: id)) else {return}
        print (url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, responce, error in
            guard let data = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode(DetailedRecipe.self, from: data)
                completion(.success(results))
                
            } catch {
                completion(.failure(error))
                print ("error in getDetailedRecipe")
            }
        }
        task.resume()
    }
    
    func getType(_ type: Types) -> String {
        
        var url: String?
        
        switch type {
        case .popular:
            url = Constants.popularRecipesURL
        case .healthy:
            url = Constants.healthyRecipesURL
        case .dessert:
            url = Constants.dessertRecipesURL
        }
        
        return url!
    }
    
    func getSortedRecipes (type: Types, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        
        let url = getType(type)
        
        guard let url = URL(string: url) else {return}
        print ("url for sorted : \(url)")
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode(SortedRecipes.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
                print ("error in getSortedRecipes")
            }
        }
        task.resume()
    }
    
    func searchRecipe (keyWord: String, completion: @escaping (Result<[RecipeId], Error>) -> Void) {
        guard let url = URL(string: Constants.searchRecipeURL+keyWord) else {return}
        print ("url for searched : \(url)")
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode([RecipeId].self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
                print ("error in searchRecipes: \(error)")
            }
        }
        task.resume()
    }
    
    func getImage(from urlString: String, isIngredient: Bool = false, completion: @escaping (Result<Data, Error>) -> Void) {
        
        var url: String?
        
        if isIngredient == true {
            url = Constants.ingredientImageURL + urlString
        } else {
            url = urlString
        }
        
        guard let url = URL(string: url!) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            completion(.success(data))
            
        }
        task.resume()
    }
    
    func convertHTML (from string: String) -> NSAttributedString?{
        do{
            let atrString = try NSAttributedString(data: string.data(using: .utf8) ?? .init(), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return atrString
        }catch{
            print("I cant convert html to string sorry")
            return nil
        }
    }
}

//MARK: - for categories

enum Categories: String {
    case maincourse, sidedish, dessert, salad, breakfast, soup, snack, drink
}

extension APICaller {
    
    func getCategoryRecipes (category: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        
        let url = Constants.categoryURL(with: category)
        
        guard let url = URL(string: url) else {return}
        print ("url for sorted : \(url)")
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode(SortedRecipes.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
                print ("error in getSortedRecipes")
            }
        }
        task.resume()
    }
}
