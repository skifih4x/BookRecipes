//
//  RatingView.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 03.03.2023.
//

import UIKit

final class RatingView: UIView {
    
    lazy var starImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star.fill")
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var ratingLabel: UILabel = {
        let view = UILabel()
        view.text = "4,5"
        view.font = UIFont(name: "Helvetica Neue Bold", size: 18)
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 180/255, green: 182/255, blue: 188/255, alpha: 0.9)
        layer.cornerRadius = 7
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(starImageView)
        addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            starImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            starImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            starImageView.heightAnchor.constraint(equalToConstant: 20),
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            
            ratingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            ratingLabel.heightAnchor.constraint(equalToConstant: 20),
            ratingLabel.widthAnchor.constraint(equalToConstant: 30),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
