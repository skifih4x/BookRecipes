//
//  MainTableViewCell.swift
//  BookRecipes
//
//  Created by Buzz on 3/1/23.
//

import UIKit
import SDWebImage

final class MainTableViewCell: UITableViewCell {
    
    private let ratingView: RatingContentView = {
        let view = RatingContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recipeImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica Neue Bold", size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: Recipe) {
        ratingView.configure(rating: "4,5")
        recipeImageView.sd_setImage(with: URL(string: model.image), placeholderImage: UIImage(named: "loading.jpg"))
        recipeNameLabel.text = model.title
    }
}

//MARK: Setup

private extension MainTableViewCell {
    
    func setup() {
        setupView()
        setConstraints()
    }
    
    func setupView() {
        clipsToBounds = true
        recipeImageView.addSubview(ratingView)
        addSubview(recipeImageView)
        addSubview(recipeNameLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            recipeNameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 10),
            recipeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recipeNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            recipeNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            ratingView.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 10),
            ratingView.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 10),
            ratingView.heightAnchor.constraint(equalToConstant: 35),
            ratingView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }

}

