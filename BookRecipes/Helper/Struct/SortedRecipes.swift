//
//  SortedRecipes.swift
//  BookRecipes
//
//  Created by User on 01.03.2023.
//

import Foundation

struct SortedRecipes: Codable {
    let results: [Recipe]
}

protocol RecipeProtocol {
    var id: Int { get }
    var image: String? { get }
    var title: String? { get }
}

struct Recipe: RecipeProtocol, Codable {
    let id : Int
    let image: String?
    let title: String?
}

struct RecipeId: Codable {
    let id : Int
}

typealias SearchedRecipes = [Recipe]
