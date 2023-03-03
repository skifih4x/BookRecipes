//
//  IngridientsTableViewHeader.swift
//  BookRecipes
//
//  Created by pvl kzntsv on 03.03.2023.
//

import UIKit

class IngridientsTableViewHeader: UITableViewHeaderFooterView {
    
    //MARK: - Elements
   
    private let tableNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ingridients"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private let numberOfItemsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10 items"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        return label
    }()
    
    
    //Set number of items
    func configure(text: String) {
        numberOfItemsLabel.text = text
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(tableNameLabel)
        contentView.addSubview(numberOfItemsLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setConstrains
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tableNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),

            numberOfItemsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberOfItemsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
        ])
    }
}

