//
//  ExampleCollectionViewCell.swift
//  BookRecipes
//
//  Created by Ян Бойко on 28.02.2023.
//

import UIKit

class ExampleCollectionViewCell: UICollectionViewCell {
    
    private let burgerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "burger1")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.text = "Egg top Burger"
        view.textAlignment = .center
        view.font = UIFont(name: "Arial", size: 16)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        view.text = "7.42"
        view.textAlignment = .center
        view.font = UIFont(name: "Arial Bold", size: 24)
        view.textColor = .red
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
        layer.cornerRadius = 10
        backgroundColor = .brown
        
        addSubview(burgerImageView)
        addSubview(backgroundTitleView)
        addSubview(nameLabel)
        addSubview(priceLabel)
    }
    
    func configureCell(imageName: String) {
        burgerImageView.image = UIImage(named: imageName)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            burgerImageView.topAnchor.constraint(equalTo: topAnchor),
            burgerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            burgerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            burgerImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backgroundTitleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            backgroundTitleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundTitleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundTitleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: backgroundTitleView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: backgroundTitleView.leadingAnchor, constant: 10),
            
            priceLabel.centerYAnchor.constraint(equalTo: backgroundTitleView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: backgroundTitleView.trailingAnchor, constant: -10)
        ])
    }
    
}
