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

struct Recipe: Codable {
    let id : Int
    let image: String
    let title: String
}

struct RecipeId: Codable {
    let id : Int
}

typealias SearchedRecipes = [Recipe]
