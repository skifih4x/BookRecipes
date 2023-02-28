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
            return "Trending now \u{1F525}"
        case .category(_):
            return "Trending now \u{1F525}"
        case .example(_):
            return "Trending now \u{1F525}"
        }
    }
}
