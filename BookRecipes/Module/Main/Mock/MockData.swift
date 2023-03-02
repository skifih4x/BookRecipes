//
//  MockData.swift
//  BookRecipes
//
//  Created by Ян Бойко on 27.02.2023.
//

import Foundation


struct MockData {
    
    static let shared = MockData()
    
    private let popular: ListSection = {
        .popular([.init(title: "", image: "loading"),
                .init(title: "", image: "loading")])
    }()
    
    private let healthy: ListSection = {
        .healthy([.init(title: "", image: "loading"),
                   .init(title: "", image: "loading")])
    }()
    
    private let dessert: ListSection = {
        .dessert([.init(title: "", image: "loading"),
                  .init(title: "", image: "loading")])
    }()
    
    var pageData: [ListSection] {
        [popular, healthy, dessert]
    }
    
    
}
