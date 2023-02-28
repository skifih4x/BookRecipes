//
//  ListSection.swift
//  BookRecipes
//
//  Created by Ян Бойко on 27.02.2023.
//

import Foundation

enum ListSection {
    case sales([ListItem])
    case category([ListItem])
    case example([ListItem])
    
    var items: [ListItem] {
        switch self {
        case .sales(let items),
                .category(let items),
                .example(let items):
            return items
        }
    }
    
    var count: Int {
        items.count
    }
    
    var title: String {
        switch self {
        case .sales(_):
            return "Акции"
        case .category(_):
            return "Категории"
        case .example(_):
            return "Примеры"
        }
    }
}
