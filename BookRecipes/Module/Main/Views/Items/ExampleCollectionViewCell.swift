//
//  ExampleCollectionViewCell.swift
//  BookRecipes
//
//  Created by Ян Бойко on 28.02.2023.
//

import UIKit

class ExampleCollectionViewCell: UICollectionViewCell {
    
    var isSaved: Bool = false
    
    private let foodImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "loadin")
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let ratingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 180/255, green: 182/255, blue: 188/255, alpha: 0.9)
        view.layer.cornerRadius = 7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let starImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star.fill")
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let ratingLabel: UILabel = {
        let view = UILabel()
        view.text = "4,5"
        view.font = UIFont(name: "Helvetica Neue Bold", size: 18)
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bookmarkButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.layer.cornerRadius = 17.5
        view.addTarget(nil, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func saveButtonTapped() {
        print("тыкнул по кнопке сохранить")
        if !isSaved {
            isSaved = true
            bookmarkImageView.image = UIImage(named: "bookmark selected")
        } else {
            isSaved = false
            bookmarkImageView.image = UIImage(named: "bookmark")
        }
    }
    
    private let bookmarkImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bookmark")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.text = "How to sharwama at home"
        view.textColor = .black
        view.font = UIFont(name: "Helvetica Neue Bold", size: 18)
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        clipsToBounds = true
        //layer.cornerRadius = 10
        addSubview(foodImageView)
        foodImageView.addSubview(ratingView)
        ratingView.addSubview(starImageView)
        ratingView.addSubview(ratingLabel)
        foodImageView.addSubview(bookmarkButton)
        bookmarkButton.addSubview(bookmarkImageView)
        addSubview(nameView)
        nameView.addSubview(nameLabel)
    }
    
    func configureCell(imageName: String) {
        foodImageView.image = UIImage(named: imageName)
    }
    
    func configure(model: SafeRecipe) {
        self.nameLabel.text = model.recipe.title
        self.foodImageView.image = UIImage(data: model.imageData)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            foodImageView.topAnchor.constraint(equalTo: topAnchor),
            foodImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            foodImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            foodImageView.bottomAnchor.constraint(equalTo: nameView.topAnchor),
            
            ratingView.topAnchor.constraint(equalTo: foodImageView.topAnchor, constant: 10),
            ratingView.leadingAnchor.constraint(equalTo: foodImageView.leadingAnchor, constant: 10),
            ratingView.heightAnchor.constraint(equalToConstant: 35),
            ratingView.widthAnchor.constraint(equalToConstant: 70),
            
            starImageView.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            starImageView.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: 7),
            starImageView.heightAnchor.constraint(equalToConstant: 20),
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: -7),
            ratingLabel.heightAnchor.constraint(equalToConstant: 20),
            ratingLabel.widthAnchor.constraint(equalToConstant: 30),
            
            bookmarkButton.topAnchor.constraint(equalTo: foodImageView.topAnchor, constant: 10),
            bookmarkButton.trailingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: -10),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 35),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 35),
            
            bookmarkImageView.centerYAnchor.constraint(equalTo: bookmarkButton.centerYAnchor),
            bookmarkImageView.centerXAnchor.constraint(equalTo: bookmarkButton.centerXAnchor),
            bookmarkImageView.heightAnchor.constraint(equalToConstant: 19),
            bookmarkImageView.widthAnchor.constraint(equalToConstant: 15),
            
            nameView.heightAnchor.constraint(equalToConstant: 30),
            nameView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: nameView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: nameView.trailingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: nameView.centerYAnchor),

        ])
    }
    
}
