//
//  MainTableViewCell.swift
//  BookRecipes
//
//  Created by Buzz on 3/1/23.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    private let ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recipeImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //TODO: "model: String" will be removed by API model
    func configure(model: String) {
        ratingView.configure(rating: "5")
        recipeImageView.image = UIImage(named: "burger1")
        recipeNameLabel.text = "How to sharwama at home"
    }
}

//MARK: Setup

private extension MainTableViewCell {
    
    func setup() {
        setupView()
        setConstraints()
    }
    
    func setupView() {
        recipeImageView.addSubview(ratingView)
        addSubview(recipeImageView)
        addSubview(recipeNameLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: recipeNameLabel.topAnchor, constant: 10),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            recipeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            recipeNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            ratingView.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 10),
            ratingView.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 10),
            ratingView.heightAnchor.constraint(equalToConstant: 35),
            ratingView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }

}

