//
//  APICaller.swift
//  BookRecipes
//
//  Created by User on 01.03.2023.
//

import Foundation
import UIKit

struct Constants {

    static let APIKey = "09713914275c4aa2bd64c3ae7d7293c9"
    static let basicURL = "https://api.spoonacular.com/recipes/"
    
    static func exactURL(with id: Int) -> String {
        return "\(basicURL)\(id)/information?apiKey=\(APIKey)"
    }
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
    
    func searchRecipe (keyWord: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        guard let url = URL(string: Constants.searchRecipeURL+keyWord) else {return}
        print ("url for searched : \(url)")
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode([Recipe].self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
                print ("error in searchRecipes: \(error)")
            }
        }
        task.resume()
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
