//
//  RecipeTableViewCell.swift
//  BookRecipes
//
//  Created by User on 07.03.2023.
//

import UIKit
import SDWebImage

class RecipeTableViewCell: UITableViewCell {
    
    static let identifier = "RecipeTableViewCell"
    
    lazy var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
 
        self.selectionStyle = .none
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



//MARK: - Setups

extension RecipeTableViewCell {
    
    func setupView() {
        
        contentView.addSubview(recipeImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(likesLabel)
    }
    
    func setupConstraints() {
        
        let screenHeight = UIScreen.main.bounds.height
        let imageHeight = screenHeight / 9.5
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: screenHeight / 7)
        ])
        
        NSLayoutConstraint.activate([
            recipeImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            recipeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeImageView.widthAnchor.constraint(equalTo: recipeImageView.heightAnchor, multiplier: 16/9),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: recipeImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: screenHeight / 14)
        ])
        
        NSLayoutConstraint.activate([
            likesLabel.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 16),
        ])
    }
    
    func setupData(recipe: DetailedRecipe) {
        recipeImageView.sd_setImage(with: URL(string: recipe.image!))
        titleLabel.text = recipe.title
        likesLabel.text = "Likes: \(recipe.aggregateLikes!)"
    }
}
