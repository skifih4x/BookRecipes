//
//  DetailedRecipe.swift
//  BookRecipes
//
//  Created by User on 01.03.2023.
//

import Foundation

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
