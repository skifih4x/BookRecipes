//
//  APICaller.swift
//  BookRecipes
//
//  Created by User on 01.03.2023.
//

import Foundation
import UIKit

struct Constants {
    
    static let APIKey = "7e31fd338a334d03aafda200f55348c0"
    static let basicURL = "https://api.spoonacular.com/recipes/"
    
    static func exactURL(with id: Int) -> String {
        return "\(basicURL)\(id)/information?apiKey=\(APIKey)"
    }
    static let popularRecipesURL = "\(basicURL)complexSearch?sort=popularity&number=10&apiKey=\(APIKey)"
    static let healthyRecipesURL = "\(basicURL)complexSearch?sort=healthiness&number=10&apiKey=\(APIKey)"
    static let dessertRecipesURL = "\(basicURL)complexSearch?sort=sugar&number=10&apiKey=\(APIKey)"
    static let randomURL = "\(basicURL)random?apiKey=\(APIKey)"
    
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
                let results = try JSONDecoder().decode(DeatiledRecipe.self, from: data)
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
    
    func getImage(from urlString: String,completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            
            completion(.success(data))
            
        }
        task.resume()
    }
}
