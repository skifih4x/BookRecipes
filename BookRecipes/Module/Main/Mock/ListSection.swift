//
//  ListSection.swift
//  BookRecipes
//
//  Created by Ян Бойко on 27.02.2023.
//

import Foundation

enum ListSection {
    case popular([ListItem])
    case healthy([ListItem])
    case dessert([ListItem])
    
    var items: [ListItem] {
        switch self {
        case .popular(let items),
                .healthy(let items),
                .dessert(let items):
            return items
        }
    }
    
    var count: Int {
        items.count
    }
    
    var title: String {
        switch self {
        case .popular(_):
            return "Popular \u{1F525}"
        case .healthy(_):
            return "Healthy \u{1F966}"
        case .dessert(_):
            return "Dessert \u{1F370}"
        }
    }
}
