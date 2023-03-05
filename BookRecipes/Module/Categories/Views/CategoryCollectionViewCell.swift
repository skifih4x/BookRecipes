//
//  CategoryCollectionViewCell.swift
//  BookRecipes
//
//  Created by User on 02.03.2023.
//

import UIKit

struct CategoryImages {
    
    static let mainCourse = UIImage(named: "MainCourse")
    static let sideDish = UIImage(named: "SideDish")
    static let dessert = UIImage(named: "Dessert")
    static let salad = UIImage(named: "Salad")
    static let breakfast = UIImage(named: "Breakfast")
    static let soup = UIImage(named: "Soup")
    static let snack = UIImage(named: "Snack")
    static let drink = UIImage(named: "Drink")
}

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "MainCourse")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var view: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.65)
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Main Course"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryCollectionViewCell {
    
    func setupView() {
        
        contentView.addSubview(imageView)
        contentView.addSubview(view)
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        
        let safeArea = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            safeArea.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: safeArea.topAnchor),
            view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            safeArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            safeArea.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10)
        ])
    }
}
