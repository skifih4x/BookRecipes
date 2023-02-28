//
//  HeaderSupplementaryView.swift
//  BookRecipes
//
//  Created by Ян Бойко on 28.02.2023.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {
    
    private let headerLabel: UILabel = {
        let view = UILabel()
        view.text = "header"
        view.textAlignment = .center
        view.font = UIFont(name: "Helvetica Neue Bold", size: 28)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(headerLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(categoryName: String) {
        headerLabel.text = categoryName
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
}
