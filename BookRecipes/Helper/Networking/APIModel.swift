//
//  DetailedRecipe.swift
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
    let image: String?
    let title: String?
}

struct RecipeId: Codable {
    let id : Int
}

struct DetailedRecipe: Codable {
    let id: Int
    let readyInMinutes: Int?
    let title: String?
    let image: String?
    let aggregateLikes: Int?
    let summary: String?
    let instructions: String?
    let extendedIngredients: [ExtendedIngredient]
}

struct ExtendedIngredient: Codable {
    let image: String?
    let name: String?
    let amount: Double?
    let unit: String? // единицы измерения
}
