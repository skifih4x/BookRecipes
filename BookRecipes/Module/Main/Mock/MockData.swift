//
//  MockData.swift
//  BookRecipes
//
//  Created by Ян Бойко on 27.02.2023.
//

import Foundation


struct MockData {
    
    static let shared = MockData()
    
    private let sales: ListSection = {
        .sales([.init(title: "", image: "burger3"),
                .init(title: "", image: "burger3"),
                .init(title: "", image: "burger3")])
    }()
    
    private let category: ListSection = {
        .category([.init(title: "Burger", image: "burger3"),
                   .init(title: "Chicken", image: "burger3"),
                   .init(title: "Hot-dog", image: "burger3"),
                   .init(title: "Pizza", image: "burger3"),
                   .init(title: "Taco", image: "burger3"),
                   .init(title: "Wok", image: "burger3")])
    }()
    
    private let example: ListSection = {
        .example([.init(title: "", image: "burger3"),
                  .init(title: "", image: "burger3"),
                  .init(title: "", image: "burger3"),])
    }()
    
    var pageData: [ListSection] {
        [sales, category, example]
    }
    
    
}
