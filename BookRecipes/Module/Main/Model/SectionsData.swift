//
//  ListSection.swift
//  BookRecipes
//
//  Created by Ян Бойко on 27.02.2023.
//

import Foundation

enum Sections {
    case popular
    case healthy
    case dessert
    
    var title: String {
        switch self {
        case .popular:
            return "Popular \u{1F525}"
        case .healthy:
            return "Healthy \u{1F966}"
        case .dessert:
            return "Dessert \u{1F370}"
        }
    }
}

struct SectionsData {
    static let shared = SectionsData()
    private let popular = Sections.popular
    private let healthy = Sections.healthy
    private let dessert = Sections.dessert
    var sectionsArray: [Sections] {
        [popular, healthy, dessert]
    }
}
