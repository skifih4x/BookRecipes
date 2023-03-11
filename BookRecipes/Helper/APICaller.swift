//
//  APICaller.swift
//  BookRecipes
//
//  Created by User on 01.03.2023.
//

import Foundation
import UIKit

struct Constants {
//    static let APIKey = "7e31fd338a334d03aafda200f55348c0"
//    static let APIKey = "3632101b02674a0e97fb8b63eb12646e"

    //static let APIKey = "7e31fd338a334d03aafda200f55348c0"
    //static let APIKey = "3632101b02674a0e97fb8b63eb12646e"

//    static let APIKey = "34f7a796b8c345a3abc987d7b2441e31"


    static let APIKey = "f492570d95e648959af5195d4547d0b0"
//    static let APIKey = "2fac697d234745afbc5804620aef2337"
//    static let APIKey = "7e31fd338a334d03aafda200f55348c0"
//    static let APIKey = "3632101b02674a0e97fb8b63eb12646e"
//    static let APIKey = "4ea5853dc94c40a296c7ac12e7fe5eb4"
//    static let APIKey = "04864a53f7464c90820b2725af2c6ba0"
//    static let APIKey = "206625f6a74745dda3cb47905f129e1c"
//    static let APIKey = "bc63ec8984094be58b7a2d77da76b373"
//    static let APIKey = "4ea5853dc94c40a296c7ac12e7fe5eb4"
//    static let APIKey = "53848099fdeb4d0d9ad71bb84a1103e2"
    //static let APIKey = "7e31fd338a334d03aafda200f55348c0"
    //static let APIKey = "3632101b02674a0e97fb8b63eb12646e"
    //static let APIKey = "4ea5853dc94c40a296c7ac12e7fe5eb4"

    //static let APIKey = "04864a53f7464c90820b2725af2c6ba0"
    //static let APIKey = "206625f6a74745dda3cb47905f129e1c"
//    static let APIKey = "bc63ec8984094be58b7a2d77da76b373"

//    static let APIKey = "4ea5853dc94c40a296c7ac12e7fe5eb4"
//    static let APIKey = "53848099fdeb4d0d9ad71bb84a1103e2"
    //static let APIKey = "37f723dc553444e88435a44768859ae4"

    //static let APIKey = "4ea5853dc94c40a296c7ac12e7fe5eb4"
    //static let APIKey = "53848099fdeb4d0d9ad71bb84a1103e2"
    
//    static let APIKey = "7e31fd338a334d03aafda200f55348c0"
//    static let APIKey = "3632101b02674a0e97fb8b63eb12646e"
//    static let APIKey = "4ea5853dc94c40a296c7ac12e7fe5eb4"
//    static let APIKey = "04864a53f7464c90820b2725af2c6ba0"
    static let APIKey = "206625f6a74745dda3cb47905f129e1c"
//    static let APIKey = "bc63ec8984094be58b7a2d77da76b373"
//    static let APIKey = "4ea5853dc94c40a296c7ac12e7fe5eb4"
//    static let APIKey = "53848099fdeb4d0d9ad71bb84a1103e2"
//    static let APIKey = "c5579ba8b4734f44b80f0348e3a39505"
//    static let APIKey = "9dffb89689f44ef994d6afae93681784"

    
    static let basicURL = "https://api.spoonacular.com/recipes/"
    
    static func exactURL(with id: Int) -> String {
        return "\(basicURL)\(id)/information?apiKey=\(APIKey)"
    }
    static let randomURL = "\(basicURL)random?apiKey=\(APIKey)"
    static let searchRecipeURL = "\(basicURL)autocomplete?number=10&apiKey=\(APIKey)&query="
    static let ingredientImageURL = "https://spoonacular.com/cdn/ingredients_100x100/"
    
    static func categoryURL(isSorted: Bool, parameter: String) -> String {
        switch isSorted {
        case true: return "\(basicURL)complexSearch?sort=\(parameter)&number=10&apiKey=\(APIKey)"
        case false : return "\(basicURL)complexSearch?type=\(parameter)&number=10&apiKey=\(APIKey)"
        }
    }

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
        
    func convertHTML (from string: String) -> NSAttributedString?{
        do{
            let atrString = try NSAttributedString(data: string.data(using: .utf8) ?? .init(), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return atrString
        }catch{
            print("error in HTML converter: \(error)")
            return nil
        }
    }
}

//MARK: - Categories

enum Categories: String {
    case maincourse, sidedish, dessert, salad, breakfast, soup, snack, drink
}

enum Types: String {
    case popularity, healthiness, sugar
}

extension APICaller {
    
    func getCategoryRecipes (sorted: Bool, searchParameter: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        
        let url = Constants.categoryURL(isSorted: sorted, parameter: searchParameter)
        
        guard let url = URL(string: url) else {return}
        print ("url for sorted : \(url)")
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode(SortedRecipes.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
                print ("error in getCategoryRecipes")
            }
        }
        task.resume()
    }
}
