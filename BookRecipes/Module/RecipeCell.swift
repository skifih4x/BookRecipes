//
//  RecipeCell.swift
//  recipes screen
//
//  Created by Вова on 03.03.2023.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    var recipeImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var recipeTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var likesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(recipeImageView)
        addSubview(recipeTitleLabel)
        addSubview(likesLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETDATA
    
    func setData(recipe: SafeRecipe) {
        recipeImageView.image = UIImage(data: recipe.imageData)
        recipeTitleLabel.text = recipe.recipe.title
        likesLabel.text = "Likes: \(recipe.recipe.aggregateLikes!)"
    }
    
    //MARK: - Constraints

    func setConstraints () {
        NSLayoutConstraint.activate([

            recipeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            recipeImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            recipeImageView.widthAnchor.constraint(equalTo: recipeImageView.heightAnchor, multiplier: 16/9),
            
            recipeTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            recipeTitleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.66),
            recipeTitleLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 20),
            recipeTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            likesLabel.topAnchor.constraint(equalTo: recipeTitleLabel.bottomAnchor, constant: 0),
            likesLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 20),
            likesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            likesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
}
